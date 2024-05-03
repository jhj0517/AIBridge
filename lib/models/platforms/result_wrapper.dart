abstract class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T) success,
    required R Function(Error<T>) error,
  });
}

class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  R fold<R>({
    required R Function(T) success,
    required R Function(Error<T>) error,
  }) {
    return success(value);
  }
}

class Error<T> extends Result<T> {

  final int errorCode;
  final String errorMessage;

  const Error({required this.errorCode, required this.errorMessage});

  @override
  R fold<R>({
    required R Function(T) success,
    required R Function(Error<T>) error,
  }) {
    return error(this);
  }
}

