import '../../members/data/member_detail_model.dart';

/// Response from `GET /check-auth` for a logged-in member session.
class CheckAuthProfile {
  const CheckAuthProfile({required this.sessionType, required this.member});

  /// e.g. `member`, `admin`
  final String sessionType;
  final MemberDetailModel member;
}
