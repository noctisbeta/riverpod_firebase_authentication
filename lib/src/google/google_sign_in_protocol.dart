// ignore_for_file: one_member_abstracts

import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:riverpod_firebase_authentication/src/google/google_sign_in_exception.dart';

/// Google sign in protocol.
abstract class GoogleSignInProtocol {
  /// Starts the Google sign in process and returns a [Future] that completes
  /// with a [UserCredential] if the sign in process is successful, or with a
  /// [GoogleSignInException] if the sign in process fails.
  AsyncResult<GoogleSignInException, UserCredential> signInWithGoogle();
}
