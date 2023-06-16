import 'package:firebase_core/firebase_core.dart';
import 'package:incrementapp/firebase_options.dart';
import 'package:incrementapp/firebase/auth/auth_user.dart';
import 'package:incrementapp/firebase/auth/auth_provider.dart';
import 'package:incrementapp/firebase/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    // Email Exceptions

    if (email.isEmpty || password.isEmpty) {
      throw MissingDetailsAuthException();
    } else if (email.indexOf('@') < 6 || email.indexOf('@') > 30) {
      throw OutOfRangeAuthException();
    } else if (email.startsWith(RegExp(r'\d'))) {
      throw CannotStartWithAuthException();
    } else if (!RegExp(
            r'^[A-Za-z0-9]+([_.][A-Za-z0-9]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*$')
        .hasMatch(email)) {
      throw InvalidEmailAuthException();
    } else if (email.contains(RegExp(r'\s'))) {
      throw CannotHaveWhiteSpace();
    }

    // Password Exceptions

    if (password.length > 50) {
      throw OutOfRangePasswordException();
    }
    if (password.toLowerCase() == 'password') {
      throw CannotBePasswordException();
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      }
      // For other type of errors
      else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    // Added this
    if (email.isEmpty || password.isEmpty) {
      throw MissingDetailsAuthException();
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
