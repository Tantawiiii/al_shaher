import 'package:al_shaher/feature/user/auth/register/data/register_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit(this._remote) : super(const BranchState());

  final RegisterRemoteDataSource _remote;

  Future<void> fetchBranches() async {
    emit(state.copyWith(loadStatus: BranchLoadStatus.loading, clearError: true));
    try {
      final list = await _remote.fetchBranches();
      emit(
        state.copyWith(
          loadStatus: BranchLoadStatus.success,
          branches: list,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadStatus: BranchLoadStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
