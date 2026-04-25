import 'package:flutter/foundation.dart';

import '../data/admin_member_model.dart';

enum AdminMembersStatus { initial, loading, loaded, error }

enum AdminMemberDetailStatus { initial, loading, loaded, error }

@immutable
class AdminMembersState {
  const AdminMembersState({
    this.status = AdminMembersStatus.initial,
    this.members = const [],
    this.errorMessage,
    this.activeFilter = true,
    this.deletedFilter = false,
    this.detailStatus = AdminMemberDetailStatus.initial,
    this.selectedMember,
    this.detailError,
    this.actionLoading = false,
  });

  final AdminMembersStatus status;
  final List<AdminMemberModel> members;
  final String? errorMessage;
  final bool activeFilter;
  final bool deletedFilter;

  final AdminMemberDetailStatus detailStatus;
  final AdminMemberModel? selectedMember;
  final String? detailError;
  final bool actionLoading;

  AdminMembersState copyWith({
    AdminMembersStatus? status,
    List<AdminMemberModel>? members,
    String? errorMessage,
    bool? activeFilter,
    bool? deletedFilter,
    AdminMemberDetailStatus? detailStatus,
    AdminMemberModel? selectedMember,
    String? detailError,
    bool? actionLoading,
    bool clearError = false,
    bool clearDetailError = false,
    bool clearSelectedMember = false,
  }) {
    return AdminMembersState(
      status: status ?? this.status,
      members: members ?? this.members,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      activeFilter: activeFilter ?? this.activeFilter,
      deletedFilter: deletedFilter ?? this.deletedFilter,
      detailStatus: detailStatus ?? this.detailStatus,
      selectedMember: clearSelectedMember
          ? null
          : (selectedMember ?? this.selectedMember),
      detailError:
          clearDetailError ? null : (detailError ?? this.detailError),
      actionLoading: actionLoading ?? this.actionLoading,
    );
  }
}
