import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../domain/entities/user.dart';
import '../domain/entities/auth_failure.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  AuthService build() => this;

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _createUserFromFirebase(firebaseUser);
    });
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      return _createUserFromFirebase(firebaseUser);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const AuthFailure.invalidCredentials();
      }

      return _createUserFromFirebase(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw const AuthFailure.invalidCredentials();
      }

      return _createUserFromFirebase(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure.cancelled();
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw const AuthFailure.invalidCredentials();
      }

      return _createUserFromFirebase(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw const AuthFailure.notAuthenticated();

      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoUrl);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e);
    } on Exception catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  Future<bool> _checkProfileComplete(firebase_auth.User user) async {
    // You can customize this based on your requirements
    return user.displayName != null && user.email != null;
  }

  Future<User> _createUserFromFirebase(firebase_auth.User firebaseUser) async {
    final isProfileComplete = await _checkProfileComplete(firebaseUser);

    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      isProfileComplete: isProfileComplete,
    );
  }
}
