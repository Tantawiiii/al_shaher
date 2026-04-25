import 'package:al_shaher/feature/user/auth/register/data/register_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._remote) : super(const RegisterState());

  final RegisterRemoteDataSource _remote;

  void setPersonalRelationships(List<String> value) {
    emit(state.copyWith(personalRelationships: value, clearError: true));
  }

  void setBranchId(int id, {String? branchName}) {
    emit(state.copyWith(branchId: id, clearError: true));
  }

  void setFatherId(int id) {
    emit(state.copyWith(fatherId: id, clearError: true));
  }


  Future<void> completeRegisterStep({
    required String name,
    required String nationalId,
    required String phoneDigits,
    String? dateOfBirthIso,
    required String city,
    required String password,
    String? gender,
    required String imageFilePath,
  }) async {
    emit(
      state.copyWith(
        status: RegisterStatus.uploadingImage,
        errorMessage: null,
      ),
    );

    try {
      final imageId = await _remote.uploadMedia(imageFilePath);
      emit(
        state.copyWith(
          status: RegisterStatus.initial,
          name: name.trim(),
          nationalId: nationalId.trim(),
          phone: _normalizePhone(phoneDigits),
          dateOfBirthIso: dateOfBirthIso ?? '',
          city: city.trim(),
          password: password,
          gender: gender,
          imageId: imageId,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> submitApplication() async {
    if (!state.canSubmitApplication) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'يرجى إكمال جميع الخطوات',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: RegisterStatus.submittingApplication,
        errorMessage: null,
      ),
    );

    try {
      await _remote.submitApplicationForm(
        name: state.name,
        nationalId: state.nationalId,
        phone: state.phone,
        dateOfBirth: state.dateOfBirthIso.isEmpty ? null : state.dateOfBirthIso,
        city: state.city,
        password: state.password,
        branchId: state.branchId!,
        fatherId: state.fatherId!,
        gender: state.gender,
        personalRelationships: state.personalRelationships,
        imageId: state.imageId!,
      );
      emit(state.copyWith(status: RegisterStatus.success, clearError: true));
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  String _normalizePhone(String digits) {
    final trimmed = digits.trim().replaceAll(RegExp(r'\s'), '');
    if (trimmed.startsWith('+')) return trimmed;
    final d = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
    return '+966$d';
  }
}
