import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../../members/data/member_detail_model.dart';
import 'check_auth_profile.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._network, this._auth);

  final NetworkService _network;
  final AuthLocalStorage _auth;

  Options get _authOptions {
    final token = _auth.getToken();
    return Options(
      headers: <String, dynamic>{
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  String _messageFromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map) {
        for (final v in errors.values) {
          if (v is List && v.isNotEmpty) return v.first.toString();
          if (v is String && v.isNotEmpty) return v;
        }
      }
      if (data['message'] != null) return data['message'].toString();
    }
    return 'حدث خطأ';
  }

  /// GET /check-auth — current user payload (same shape as member detail `data`).
  Future<CheckAuthProfile> fetchCheckAuth() async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        ApiEndpoints.checkAuth,
        options: _authOptions,
      );
      final body = res.data;
      if (body == null) {
        throw Exception('استجابة غير صالحة');
      }
      final rawData = body['data'];
      if (rawData is! Map) {
        throw Exception('استجابة غير صالحة');
      }
      final map = Map<String, dynamic>.from(rawData);
      final sessionType = body['type']?.toString() ?? 'member';
      return CheckAuthProfile(
        sessionType: sessionType,
        member: MemberDetailModel.fromJson(map),
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<String> deleteAccount() async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.userDeleteAccount,
        options: _authOptions,
      );
      final body = res.data;
      if (body != null && body['message'] != null) {
        return body['message'].toString();
      }
      return 'تم حذف الحساب';
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
