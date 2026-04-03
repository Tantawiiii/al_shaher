class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://tree.dentin.cloud/api';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// Relative paths under [ApiConstants.baseUrl].
class ApiEndpoints {
  ApiEndpoints._();

  static const String applicationForm = '/application-form';
  static const String media = '/media';
  static const String branchIndex = '/branch/index';
  static const String memberIndex = '/member/index';
  static const String login = '/login';
}
