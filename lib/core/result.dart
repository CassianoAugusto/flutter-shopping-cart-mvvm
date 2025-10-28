class Result<T> {
  final T? data;
  final String? error;

  bool get isSuccess => error == null;
  bool get isError => error != null;

  const Result._(this.data, this.error);

  factory Result.success(T data) => Result._(data, null);
  factory Result.failure(String message) => Result._(null, message);
}
