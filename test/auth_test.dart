import 'package:moodnotes/services/auth/auth_exceptions.dart';
import 'package:moodnotes/services/auth/auth_provider.dart';
import 'package:moodnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test('Should not be initialized', () {
      expect(provider.isInitialized, false);
    });
    test('Should not logout if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("Should be able to initialize", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test("User should be null after initialization", () async {
      expect(provider.currentUser, isNull);
    });
    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("Create User should be able to delegate to login", () async {
      final badEmail = provider.createUser(
        email: "dude@test.com",
        password: "hell_yes",
      );
      expect(badEmail, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword = provider.createUser(
        email: "test@test.com",
        password: "password",
      );
      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "test@test.com",
        password: "hell_yes",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Send Email verification", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to logout and login again.", () async {
      await provider.logOut();
      final user = provider.currentUser;
      expect(user, isNull);

      await provider.logIn(
        email: "test@test.com",
        password: "hell_yes",
      );
      final newUser = provider.currentUser;
      expect(newUser, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      _isInitialized = true;
    });
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'dude@test.com') {
      throw UserNotFoundAuthException("User not found");
    }
    if (password == 'password') {
      throw WrongPasswordAuthException("Invalid password");
    }
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException("User not logged in");
    await Future.delayed(const Duration(milliseconds: 100));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInException("User not logged in");
    await Future.delayed(const Duration(milliseconds: 100));
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
