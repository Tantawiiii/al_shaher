import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/profile_remote_data_source.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._remote) : super(const ProfileState());

  final ProfileRemoteDataSource _remote;

  Future<void> loadMyProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));
    try {
      final profile = await _remote.fetchCheckAuth();
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          profile: profile,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> deleteMyAccount() async {
    emit(
      state.copyWith(
        deleteAccountStatus: DeleteAccountStatus.loading,
        clearDeleteAccountMessage: true,
      ),
    );
    try {
      final message = await _remote.deleteAccount();
      emit(
        state.copyWith(
          deleteAccountStatus: DeleteAccountStatus.success,
          deleteAccountMessage: message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          deleteAccountStatus: DeleteAccountStatus.failure,
          deleteAccountMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
