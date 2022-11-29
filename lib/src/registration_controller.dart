import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

/// Firebase authentication controller.
class RegistrationController {
  /// Default constructor.
  RegistrationController(this._auth);

  /// Firebase auth instance.
  final FirebaseAuth _auth;

  /// Provides the controller.
  static final provider = Provider(
    (ref) => RegistrationController(FirebaseAuth.instance),
  );

  /// Creates a user with [email] and [password].
  AsyncResult<FirebaseAuthException, UserCredential> createUser(
    String email,
    String password,
  ) =>
      Task(
        () => _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).attempt<FirebaseAuthException>().peekEither(
            (exception) => Logger().e(
              'Error creating user: $exception',
              exception,
              StackTrace.current,
            ),
            (userCredential) => Logger().i('Created user: $userCredential'),
          );

  /// Checks if the current user has their email verified.
  AsyncResult<Exception, bool> checkEmailVerification() =>
      Option.of(_auth.currentUser).match(
        none: () => Task.value(Left(Exception('No user signed in'))),
        some: (user) => Task.fromVoid(() => user.reload())
            .attempt<Exception>()
            .mapEitherRight((_) => user.emailVerified),
      );

  /// Resends a verification email to the current user.
  AsyncResult<Exception, Unit> resendEmailVerification(
    ActionCodeSettings settings,
  ) =>
      Option.of(_auth.currentUser).match(
        none: () => Task.value(Left(Exception('No user logged in'))),
        some: (user) => _resendEmailVerificationRaw(settings, user),
      );

  AsyncResult<Exception, Unit> _resendEmailVerificationRaw(
    ActionCodeSettings settings,
    User user,
  ) =>
      Task.fromVoid(() => user.sendEmailVerification(settings))
          .attempt<Exception>();
}
