import 'api_exception.dart';

/// Represents the result of a network request.
///
/// A request can either succeed with data
/// or fail with an [ApiException].
sealed class ApiResult<T> {
  const ApiResult();
}

/// Represents a successful network response.
final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;
}

/// Represents a failed network response.
final class Failure<T> extends ApiResult<T> {
  const Failure(this.exception);

  final ApiException exception;
}