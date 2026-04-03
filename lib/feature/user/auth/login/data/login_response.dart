import 'package:flutter/foundation.dart';

@immutable
class LoginResponse {
  const LoginResponse({
    required this.message,
    required this.type,
    required this.token,
    required this.user,
  });

  final String message;
  final String type;
  final String token;
  final Map<String, dynamic> user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid login response: data');
    }
    final token = json['token']?.toString();
    if (token == null || token.isEmpty) {
      throw const FormatException('Invalid login response: token');
    }
    return LoginResponse(
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      token: token,
      user: data,
    );
  }
}
