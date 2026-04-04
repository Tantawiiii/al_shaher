import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/members_remote_data_source.dart';
import 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  MembersCubit(this._remote) : super(const MembersState());

  final MembersRemoteDataSource _remote;

  Future<void> loadMembers() async {
    if (isClosed) return;
    emit(state.copyWith(status: MembersStatus.loading, clearError: true));
    try {
      final members = await _remote.fetchMembers();
      if (!isClosed) {
        emit(state.copyWith(status: MembersStatus.loaded, members: members));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: MembersStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> loadMemberDetails(int memberId) async {
    if (isClosed) return;
    emit(state.copyWith(
      detailStatus: MemberDetailStatus.loading,
      clearDetailError: true,
      clearSelectedMember: true,
    ));
    try {
      final member = await _remote.fetchMemberDetails(memberId);
      if (!isClosed) {
        emit(state.copyWith(
          detailStatus: MemberDetailStatus.loaded,
          selectedMember: member,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          detailStatus: MemberDetailStatus.error,
          detailError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }
}
