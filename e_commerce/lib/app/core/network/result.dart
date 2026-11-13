/// Represents the two possible outcomes of a repository operation.
///
/// A sealed type makes success and failure handling explicit and type-safe.
sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;
}

/// Successful operation containing data of type [T].
final class Success<T, E> extends Result<T, E> {
  final T data;

  const Success(this.data);
}

/// Failed operation containing an error of type [E].
final class Failure<T, E> extends Result<T, E> {
  final E error;

  const Failure(this.error);
}
