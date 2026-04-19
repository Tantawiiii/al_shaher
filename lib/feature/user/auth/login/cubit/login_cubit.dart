import 'package:al_shaher/core/storage/auth_local_storage.dart';
import 'package:al_shaher/feature/user/auth/register/data/register_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._remote, this._auth) : super(const LoginState());

  final RegisterRemoteDataSource _remote;
  final AuthLocalStorage _auth;

  Future<void> submit({
    required String phoneDigits,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));
    try {
     // final phone = _normalizePhone(phoneDigits);
      final result = await _remote.login(phone: phoneDigits, password: password);
      await _auth.saveSession(
        token: result.token,
        type: result.type,
        user: result.user,
      );
      emit(state.copyWith(status: LoginStatus.success, userType: result.type));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // String _normalizePhone(String digits) {
  //   final trimmed = digits.trim().replaceAll(RegExp(r'\s'), '');
  //   if (trimmed.startsWith('+')) return trimmed;
  //   final d = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
  //   return '+966$d';
  // }
}
