import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:functional/functional.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_firebase_authentication/src/google/google_sign_in_exception.dart';
import 'package:riverpod_firebase_authentication/src/google/google_sign_in_protocol.dart';

/// Google sign in controller.
class GoogleSignInController implements GoogleSignInProtocol {
  /// Default constructor.
  GoogleSignInController(this._auth);

  /// Auth.
  final FirebaseAuth _auth;

  /// Provides the controller.
  static final provider = Provider.autoDispose<GoogleSignInController>(
    (ref) => GoogleSignInController(FirebaseAuth.instance),
  );

  @override
  AsyncResult<GoogleSignInException, UserCredential> signInWithGoogle() =>
      Task(() => GoogleSignIn().signIn())
          .map(Option.of)
          .map(
            (optAcc) => optAcc.toEither(
              () =>
                  const GoogleSignInException('Error signing in with Google.'),
            ),
          )
          .bindEither(_getCredential);

  AsyncResult<GoogleSignInException, UserCredential> _getCredential(
    GoogleSignInAccount acc,
  ) =>
      Task(() => acc.authentication)
          .attempt<PlatformException>()
          .mapEitherLeft(
            (platExc) =>
                const GoogleSignInException('Error signing in with Google.'),
          )
          .bindEither(_getCredentiaFromFirebase);

  AsyncResult<GoogleSignInException, UserCredential> _getCredentiaFromFirebase(
    GoogleSignInAuthentication googleAuth,
  ) =>
      Task(
        () => _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        ),
      ).attempt<FirebaseAuthMultiFactorException>().mapEitherLeft(
            (fireExc) =>
                const GoogleSignInException('Error signing in with Google.'),
          );
}
