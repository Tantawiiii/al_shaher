import 'package:flutter/foundation.dart';

enum RequestStatus { initial, loading, success, failure }

@immutable
class RequestState {
  const RequestState({
    this.status = RequestStatus.initial,
    this.errorMessage,
  });

  final RequestStatus status;
  final String? errorMessage;

  RequestState copyWith({
    RequestStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RequestState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
