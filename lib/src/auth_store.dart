import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_firebase_authentication/src/log_profile.dart';

/// A [StateNotifier] that manages the authentication state of the current user.
/// If no user is signed in, the state is [None], otherwise it is [Some] with
/// the [User] object.
class AuthStore extends StateNotifier<Option<User>> {
  /// Default constructor.
  AuthStore(
    this._auth,
  ) : super(const None()) {
    _subscription = _auth.authStateChanges().listen(
          (user) => tap(
            tapped: Option.of(user).match(
              none: () => state = const None(),
              some: (user) => state = Some(user),
            ),
            effect: () => myLog.d('Auth state changed: $user'),
          ),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Firebase authStateChanges subscription.
  late final StreamSubscription _subscription;

  /// Firebase auth instance.
  final FirebaseAuth _auth;

  /// Provides the [AuthStore].
  static final provider =
      StateNotifierProvider.autoDispose<AuthStore, Option<User>>(
    (ref) => AuthStore(FirebaseAuth.instance),
  );

  /// True if the current state holds a user, false otherwise.
  bool get isLoggedIn => state.match(none: () => false, some: (user) => true);

  /// Call only if user is logged in.
  bool isEmailVerified() => state.match(
        none: () => tap(
          tapped: false,
          effect: () =>
              myLog.e('Called isEmailVerified() when user is not logged in'),
        ),
        some: (user) => user.emailVerified,
      );

  /// Returns the current user [Option].
  Option<User> get user => state;
}
