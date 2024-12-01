import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.cancelled() = _Cancelled;
  const factory AuthFailure.serverError() = _ServerError;
  const factory AuthFailure.invalidCredentials() = _InvalidCredentials;
  const factory AuthFailure.userNotFound() = _UserNotFound;
  const factory AuthFailure.emailAlreadyInUse() = _EmailAlreadyInUse;
  const factory AuthFailure.weakPassword() = _WeakPassword;
  const factory AuthFailure.notAuthenticated() = _NotAuthenticated;
  const factory AuthFailure.unknown(String message) = _Unknown;

  factory AuthFailure.fromFirebaseException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return const AuthFailure.userNotFound();
      case 'wrong-password':
        return const AuthFailure.invalidCredentials();
      case 'email-already-in-use':
        return const AuthFailure.emailAlreadyInUse();
      case 'weak-password':
        return const AuthFailure.weakPassword();
      default:
        return AuthFailure.unknown(
            exception.message ?? 'Unknown error occurred');
    }
  }

  factory AuthFailure.fromException(Exception exception) {
    return AuthFailure.unknown(exception.toString());
  }
}
