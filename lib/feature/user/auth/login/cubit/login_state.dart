import 'package:flutter/foundation.dart';

enum LoginStatus { initial, loading, success, failure }

@immutable
class LoginState {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.userType,
  });

  final LoginStatus status;
  final String? errorMessage;
  final String? userType;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? userType,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      userType: userType ?? this.userType,
    );
  }
}
