class UserNotFoundAuthException implements Exception {
  String cause;
  UserNotFoundAuthException(this.cause);
}

class WrongPasswordAuthException implements Exception {
  String cause;
  WrongPasswordAuthException(this.cause);
}

class WeakPasswordAuthException implements Exception {
  String cause;
  WeakPasswordAuthException(this.cause);
}

class EmailAlreadyInUseAuthException implements Exception {
  String cause;
  EmailAlreadyInUseAuthException(this.cause);
}

class InvalidEmailAuthException implements Exception {
  String cause;
  InvalidEmailAuthException(this.cause);
}

// generic exception
class GenericAuthException implements Exception {
  String cause;
  GenericAuthException(this.cause);
}

class UserNotLoggedInException implements Exception {
  String cause;
  UserNotLoggedInException(this.cause);
}
