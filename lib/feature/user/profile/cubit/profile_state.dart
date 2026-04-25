import '../data/check_auth_profile.dart';

enum ProfileStatus { initial, loading, loaded, failure }
enum DeleteAccountStatus { idle, loading, success, failure }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.deleteAccountStatus = DeleteAccountStatus.idle,
    this.profile,
    this.errorMessage,
    this.deleteAccountMessage,
  });

  final ProfileStatus status;
  final DeleteAccountStatus deleteAccountStatus;
  final CheckAuthProfile? profile;
  final String? errorMessage;
  final String? deleteAccountMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    DeleteAccountStatus? deleteAccountStatus,
    CheckAuthProfile? profile,
    String? errorMessage,
    String? deleteAccountMessage,
    bool clearError = false,
    bool clearProfile = false,
    bool clearDeleteAccountMessage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      profile: clearProfile ? null : (profile ?? this.profile),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      deleteAccountMessage: clearDeleteAccountMessage
          ? null
          : (deleteAccountMessage ?? this.deleteAccountMessage),
    );
  }
}
