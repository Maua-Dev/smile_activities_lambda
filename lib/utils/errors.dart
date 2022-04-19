class Errors implements Exception {
  final String message;
  Errors(this.message);
}

class AuthenticationError extends Errors {
  AuthenticationError() : super('Authentication Error');
}

class InternalServerError extends Errors {
  InternalServerError(String message) : super(message);
}
