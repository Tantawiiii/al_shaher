import 'package:flutter_bloc/flutter_bloc.dart';


import '../../register/data/register_remote_data_source.dart';
import 'father_state.dart';

class FatherCubit extends Cubit<FatherState> {
  FatherCubit(this._remote) : super(const FatherState());

  final RegisterRemoteDataSource _remote;

  Future<void> loadForBranch(int branchId) async {
    emit(
      FatherState(
        loadStatus: FatherLoadStatus.loading,
        branchId: branchId,
        errorMessage: null,
      ),
    );
    try {
      final list = await _remote.fetchMembersForBranch(branchId);
      emit(
        FatherState(
          loadStatus: FatherLoadStatus.success,
          members: list,
          branchId: branchId,
        ),
      );
    } catch (e) {
      emit(
        FatherState(
          loadStatus: FatherLoadStatus.failure,
          branchId: branchId,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void reset() {
    emit(const FatherState());
  }
}
