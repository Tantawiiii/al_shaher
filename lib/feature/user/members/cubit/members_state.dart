import 'package:flutter/foundation.dart';

import '../../auth/register/data/models/member_model.dart';
import '../data/member_detail_model.dart';

enum MembersStatus { initial, loading, loaded, error }

enum MemberDetailStatus { initial, loading, loaded, error }

@immutable
class MembersState {
  const MembersState({
    this.status = MembersStatus.initial,
    this.members = const [],
    this.errorMessage,
    this.detailStatus = MemberDetailStatus.initial,
    this.selectedMember,
    this.detailError,
  });

  final MembersStatus status;
  final List<MemberModel> members;
  final String? errorMessage;

  final MemberDetailStatus detailStatus;
  final MemberDetailModel? selectedMember;
  final String? detailError;

  MembersState copyWith({
    MembersStatus? status,
    List<MemberModel>? members,
    String? errorMessage,
    bool clearError = false,
    MemberDetailStatus? detailStatus,
    MemberDetailModel? selectedMember,
    String? detailError,
    bool clearDetailError = false,
    bool clearSelectedMember = false,
  }) {
    return MembersState(
      status: status ?? this.status,
      members: members ?? this.members,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      detailStatus: detailStatus ?? this.detailStatus,
      selectedMember: clearSelectedMember
          ? null
          : (selectedMember ?? this.selectedMember),
      detailError:
          clearDetailError ? null : (detailError ?? this.detailError),
    );
  }
}
