import 'package:aica_app/config/routes/page_transitions.dart';
import 'package:aica_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:aica_app/features/auth/presentation/screens/complete_profile.dart';
import 'package:aica_app/features/auth/presentation/screens/login_screen.dart';
import 'package:aica_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:aica_app/features/auth/presentation/widgets/auth_loading_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/providers/auth_provider.dart';
import '../../features/auth/domain/enums/auth_status.dart';

class RouterNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = ref.watch(authProvider);
    final path = state.uri.path;
    final isAuthFlow = path.startsWith('/auth');
    final isCompletingProfile = path == '/auth/complete-profile';

    switch (authState.status) {
      case AuthStatus.initial:
        return null;

      case AuthStatus.unauthenticated:
        return isAuthFlow ? null : '/auth';

      case AuthStatus.profileIncomplete:
        return isCompletingProfile ? null : '/auth/complete-profile';

      case AuthStatus.authenticated:
        if (isAuthFlow || isCompletingProfile) {
          return '/';
        }
        return null;
    }
  }
}

final routerNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RouterNotifier, void>(() {
  return RouterNotifier();
});

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state changes
  ref.watch(authProvider);
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // Added for debugging
    redirect: notifier.redirect,
    routes: [
      // Authentication routes
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const AuthLoadingWrapper(child: AuthScreen()),
        ),
        routes: [
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const AuthLoadingWrapper(child: LoginScreen()),
            ),
          ),
          GoRoute(
            path: 'signup',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const AuthLoadingWrapper(child: SignupScreen()),
            ),
          ),
          GoRoute(
            path: '/complete-profile',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const AuthLoadingWrapper(
                  child:
                      PopScope(canPop: false, child: CompleteProfileScreen())),
            ),
          ),
        ],
      ),
      GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const CompleteProfileScreen(),
              )),

      GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const CompleteProfileScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
