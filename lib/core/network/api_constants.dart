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
  static const String member = '/member';
  static const String memberIndex = '/member/index';
  static const String memberDelete = '/member/delete';
  static const String login = '/login';
  static const String membersTree = '/members/tree';
  static const String checkAuth = '/check-auth';
  static const String addMemberPublic = '/add-member-public';
  static const String myCreatedMembers = '/my-created-members';
  static const String userDeleteAccount = '/delete-account';

  // Events
  static const String event = '/event';
  static const String eventIndex = '/event/index';
  static const String eventDelete = '/event/delete';
  static const String eventAttendance = '/event-attendance';

  // News
  static const String news = '/news';
  static const String newsIndex = '/news/index';
  static const String newsDelete = '/news/delete';

  // Admin Permissions
  static const String adminIndex = '/admin/index';
  static const String admin = '/admin';
}
