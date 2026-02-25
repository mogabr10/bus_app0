/// A simple Result type for error handling without exceptions.
///
/// Prefer using [fpdart]'s `Either` for more complex scenarios.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, {this.exception});
  final String message;
  final Exception? exception;
}
