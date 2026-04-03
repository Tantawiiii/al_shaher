import 'package:flutter/foundation.dart';

enum LoginStatus { initial, loading, success, failure }

@immutable
class LoginState {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
