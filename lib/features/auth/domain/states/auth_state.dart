import 'package:aica_app/features/auth/domain/enums/auth_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    User? user,
    String? error,
    @Default(false) bool isLoading,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
}
