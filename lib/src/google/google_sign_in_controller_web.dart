import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_firebase_authentication/src/google/google_sign_in_exception.dart';
import 'package:riverpod_firebase_authentication/src/google/google_sign_in_protocol.dart';
import 'package:riverpod_firebase_authentication/src/log_profile.dart';

/// Google sign in controller.
class GoogleSignInControllerWeb implements GoogleSignInProtocol {
  /// Default constructor.
  const GoogleSignInControllerWeb(this._auth);

  /// Firebase auth instance.
  final FirebaseAuth _auth;

  /// Provides the [GoogleSignInControllerWeb].
  static final provider = Provider.autoDispose<GoogleSignInControllerWeb>(
    (ref) => GoogleSignInControllerWeb(FirebaseAuth.instance),
  );

  @override
  AsyncResult<GoogleSignInException, UserCredential> signInWithGoogle() => Task(
        () => _auth.signInWithPopup(
          GoogleAuthProvider(),
        ),
      )
          .attempt<FirebaseAuthMultiFactorException>()
          .mapEitherLeft(
            (fireExc) => GoogleSignInException(
              fireExc.message ?? 'Error signing in with Google on web.',
            ),
          )
          .peekEither(
            (exception) =>
                myLog.e('Error signing in with Google on web: $exception'),
            (userCredential) =>
                myLog.i('Signed in with Google on web: $userCredential'),
          );
}
