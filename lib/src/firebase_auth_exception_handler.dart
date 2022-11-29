///
class FirebaseAuthExceptionHandler {
  /// todo
  void handle() {}

  /// List of all possible error codes
  static final List<String> codes = [
    'expired-action-code',
    'invalid-action-code',
    'user-disabled',
    'user-not-found',
    'weak-password',
    'auth/invalid-email',
    'auth/missing-android-pkg-name',
    'auth/missing-continue-uri',
    'auth/missing-ios-bundle-id',
    'auth/invalid-continue-uri',
    'auth/unauthorized-continue-uri',
    'auth/user-not-found',
    'invalid-email',
    'wrong-password',
    'email-already-in-use',
    'operation-not-allowed',
  ];
}
