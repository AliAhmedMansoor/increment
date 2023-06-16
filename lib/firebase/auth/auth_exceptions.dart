// Login Exceptions
class UserNotFoundAuthException implements Exception {}

class MissingEmailException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class MissingDetailsAuthException implements Exception {}

// Register Exceptions
class WeakPasswordAuthException implements Exception {}

class CannotBePasswordException implements Exception {}

class OutOfRangePasswordException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class OutOfRangeAuthException implements Exception {}

class CannotStartWithAuthException implements Exception {}

class CannotHaveWhiteSpace implements Exception {}

// Generic Exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
