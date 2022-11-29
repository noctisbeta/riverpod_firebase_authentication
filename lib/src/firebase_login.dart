import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_firebase_authentication/src/log_profile.dart';

/// Firebase auth functions related to login.
class FirebaseLogin {
  /// Default constructor.
  FirebaseLogin(this._auth);

  /// Firebase auth instance.
  final FirebaseAuth _auth;

  /// Provides the controller.
  static final provider = Provider(
    (ref) => FirebaseLogin(FirebaseAuth.instance),
  );

  /// Sign in with [email] and [password].
  AsyncResult<FirebaseAuthException, UserCredential> login(
    String email,
    String password,
  ) =>
      Task(
        () => _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).attempt<FirebaseAuthException>().peekEither(
            (exception) => myLog.e(
              'Error logging in: $exception',
              exception,
              StackTrace.current,
            ),
            (userCredential) => myLog.i('Logged in: $userCredential'),
          );

  /// Sends a password reset email to [email] using [settings].
  AsyncResult<FirebaseAuthException, Unit> sendPasswordReset(
    String email,
    ActionCodeSettings settings,
  ) =>
      Task.fromVoid(
        () => _auth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: settings,
        ),
      ).attempt<FirebaseAuthException>().peekEither(
            (exception) => myLog.e(
              'Error sending password reset email: ${exception.message}',
              exception,
              StackTrace.current,
            ),
            (_) => myLog.i('Password reset email sent'),
          );

  /// Completes the password reset.
  AsyncResult<FirebaseAuthException, Unit> confirmPasswordReset(
    String password,
    String oobCode,
  ) =>
      Task.fromVoid(
        () => _auth.confirmPasswordReset(
          newPassword: password,
          code: oobCode,
        ),
      ).attempt<FirebaseAuthException>().peekEither(
            (exception) => myLog.e(
              'Error resetting password: ${exception.message}',
              exception,
              StackTrace.current,
            ),
            (_) => myLog.i('Password reset successful'),
          );
}
