import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/requests_remote_data_source.dart';
import 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit(this._remote) : super(const RequestState());

  final RequestsRemoteDataSource _remote;

  Future<void> submitFatherRequest({
    required int fatherId,
    required String name,
    required String gender,
    required String dateOfBirth,
    required String phone,
    required String nationalId,
    required String password,
    String? dateOfDeath,
    required bool dead,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    try {
      final body = <String, dynamic>{
        'type': 'father',
        'name': name,
        'gender': gender,
        'father_id': fatherId,
        'date_of_birth': dateOfBirth,
        'phone': phone,
        'national_id': nationalId,
        'password': password,
        'dead': dead,
        if (dateOfDeath != null && dateOfDeath.isNotEmpty)
          'date_of_death': dateOfDeath,
      };
      await _remote.addMemberPublic(body);
      if (!isClosed) {
        emit(state.copyWith(status: RequestStatus.success));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            errorMessage: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    }
  }

  Future<void> submitSonRequest({
    required int fatherId,
    required String name,
    required String gender,
    required String phone,
    required String nationalId,
    required String password,
    required String dateOfBirth,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    try {
      await _remote.addMemberPublic(<String, dynamic>{
        'type': 'son',
        'name': name,
        'gender': gender,
        'father_id': fatherId,
        'phone': phone,
        'national_id': nationalId,
        'password': password,
        'date_of_birth': dateOfBirth,
      });
      if (!isClosed) {
        emit(state.copyWith(status: RequestStatus.success));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            errorMessage: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    }
  }

  void reset() {
    if (!isClosed) {
      emit(const RequestState());
    }
  }
}
