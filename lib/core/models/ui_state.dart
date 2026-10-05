import '../errors/failures.dart';

enum Status { initial, loading, success, empty, error }

class UIState<T> {
  final Status status;
  final T? data;
  final String? errorMessage;
  final Failure? failure;

  const UIState._({
    required this.status,
    this.data,
    this.errorMessage,
    this.failure,
  });

  factory UIState.initial() => const UIState._(status: Status.initial);
  factory UIState.loading() => const UIState._(status: Status.loading);
  factory UIState.success(T data) => UIState._(status: Status.success, data: data);
  factory UIState.empty() => const UIState._(status: Status.empty);
  factory UIState.error(Failure failure) => UIState._(
        status: Status.error,
        errorMessage: failure.message,
        failure: failure,
      );

  bool get isInitial => status == Status.initial;
  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isEmpty => status == Status.empty;
  bool get isError => status == Status.error;
}
