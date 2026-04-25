import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import 'admin_permission_model.dart';

class AdminPermissionsRemoteDataSource {
  AdminPermissionsRemoteDataSource(this._network, this._auth);

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
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'حدث خطأ';
  }

  Future<AdminPermissionsPaginatedResponse> fetchAdmins({int page = 1}) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        '${ApiEndpoints.adminIndex}?page=$page',
        options: _authOptions,
      );
      final body = res.data;
      if (body == null || body['data'] is! List) {
        return AdminPermissionsPaginatedResponse(
          admins: [],
          currentPage: 1,
          lastPage: 1,
          total: 0,
        );
      }

      final admins = (body['data'] as List)
          .whereType<Map>()
          .map((e) => AdminPermissionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      final meta = body['meta'] as Map<String, dynamic>?;

      return AdminPermissionsPaginatedResponse(
        admins: admins,
        currentPage: meta?['current_page'] ?? 1,
        lastPage: meta?['last_page'] ?? 1,
        total: meta?['total'] ?? admins.length,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> toggleSuperAdmin(int adminId) async {
    try {
      await _network.client.put<Map<String, dynamic>>(
        '${ApiEndpoints.admin}/$adminId/super_admin',
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
