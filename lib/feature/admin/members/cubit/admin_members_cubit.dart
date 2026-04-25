import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/admin_members_remote_data_source.dart';
import 'admin_members_state.dart';

class AdminMembersCubit extends Cubit<AdminMembersState> {
  AdminMembersCubit(this._remote) : super(const AdminMembersState());

  final AdminMembersRemoteDataSource _remote;

  Future<void> loadMembers({
    required bool active,
    bool deleted = false,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
      status: AdminMembersStatus.loading,
      activeFilter: active,
      deletedFilter: deleted,
      clearError: true,
    ));
    try {
      final members = await _remote.fetchMembers(
        active: active,
        deleted: deleted,
      );
      if (!isClosed) {
        emit(state.copyWith(
          status: AdminMembersStatus.loaded,
          members: members,
          activeFilter: active,
          deletedFilter: deleted,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: AdminMembersStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> loadMemberDetails(int memberId) async {
    if (isClosed) return;
    emit(state.copyWith(
      detailStatus: AdminMemberDetailStatus.loading,
      clearDetailError: true,
      clearSelectedMember: true,
    ));
    try {
      final member = await _remote.fetchMemberDetails(memberId);
      if (!isClosed) {
        emit(state.copyWith(
          detailStatus: AdminMemberDetailStatus.loaded,
          selectedMember: member,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          detailStatus: AdminMemberDetailStatus.error,
          detailError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> toggleActive(int memberId) async {
    if (isClosed) return;
    emit(state.copyWith(actionLoading: true));
    try {
      await _remote.toggleActive(memberId);
      await loadMemberDetails(memberId);
      await loadMembers(
        active: state.activeFilter,
        deleted: state.deletedFilter,
      );
      if (!isClosed) emit(state.copyWith(actionLoading: false));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          actionLoading: false,
          detailError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> toggleDead(int memberId) async {
    if (isClosed) return;
    emit(state.copyWith(actionLoading: true));
    try {
      await _remote.toggleDead(memberId);
      await loadMemberDetails(memberId);
      await loadMembers(
        active: state.activeFilter,
        deleted: state.deletedFilter,
      );
      if (!isClosed) emit(state.copyWith(actionLoading: false));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          actionLoading: false,
          detailError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> deleteMember(int memberId) async {
    if (isClosed) return;
    emit(state.copyWith(actionLoading: true));
    try {
      await _remote.deleteMembers([memberId]);
      await loadMembers(
        active: state.activeFilter,
        deleted: state.deletedFilter,
      );
      if (!isClosed) emit(state.copyWith(actionLoading: false));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          actionLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }
}
