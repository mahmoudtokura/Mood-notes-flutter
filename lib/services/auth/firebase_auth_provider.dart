import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodnotes/services/auth/auth_provider.dart';
import 'package:moodnotes/services/auth/auth_user.dart';
import 'package:moodnotes/services/auth/auth_exceptions.dart';

class FirebaseAuthProvider extends AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException(
          "User not logged in.",
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException(
          "User not logged in.",
        );
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException(
          "Email already in use.",
        );
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException(
          "Email is invalid.",
        );
      } else {
        throw UserNotLoggedInException(
          "Error: ${e.code}",
        );
      }
    } catch (e) {
      throw GenericAuthException(
        e.toString(),
      );
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      return AuthUser.fromFirebase(user);
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException(
          "User not logged in.",
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException(
          "User not found.",
        );
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException(
          "Wrong password.",
        );
      } else {
        throw GenericAuthException(
          "Error: ${e.code}",
        );
      }
    } catch (e) {
      throw GenericAuthException(
        "Error: ${e.toString()}",
      );
    }
  }

  @override
  Future<void> logOut() async {
    final user = currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException(
        "User not logged in.",
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException(
        "User not logged in.",
      );
    }
  }
}
