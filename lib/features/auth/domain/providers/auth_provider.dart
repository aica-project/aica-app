// lib/features/auth/domain/providers/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../states/auth_state.dart';
import '../../services/auth_service.dart';
import '../enums/auth_status.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);

    // Start with unauthenticated state
    state = const AuthState(status: AuthStatus.unauthenticated);

    // Then check actual auth status
    _initializeAuth();

    return state;
  }

  Future<void> _initializeAuth() async {
    try {
      final user = await _authService.getCurrentUser();

      if (user != null) {
        final isUserExist =
            await _authService.isUserExist(user.email, user.token);

        if (!isUserExist) {
          state = const AuthState(status: AuthStatus.unauthenticated);
          return;
        }

        state = AuthState(
          status: user.isProfileComplete
              ? AuthStatus.authenticated
              : AuthStatus.profileIncomplete,
          user: user,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    print("HELLLLLLLLO");
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user);
      state = AuthState(
        status: user.isProfileComplete
            ? AuthStatus.authenticated
            : AuthStatus.profileIncomplete,
        user: user,
      );

      print(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signInWithGoogle();
      state = AuthState(
        status: user.isProfileComplete
            ? AuthStatus.authenticated
            : AuthStatus.profileIncomplete,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = AuthState(
        status: AuthStatus.profileIncomplete,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        status: AuthStatus.unauthenticated,
      );
      throw e;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> updateProfileCompletion() async {
    // state = state.copyWith(isLoading: true, error: null);
    // try {
    //   // Mise à jour du user avec le profil complété
    //   final updatedUser = await _authService.updateProfile(
    //     userId: state.user!.id,
    //     isProfileComplete: true,
    //   );

    //   state = AuthState(
    //     status: AuthStatus.authenticated, // Change le statut en authenticated
    //     user: updatedUser,
    //   );
    // } catch (e) {
    //   state = state.copyWith(
    //     isLoading: false,
    //     error: e.toString(),
    //   );
    // }
  }
}
