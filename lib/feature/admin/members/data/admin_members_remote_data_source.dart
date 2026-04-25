import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import 'admin_member_model.dart';

class AdminMembersRemoteDataSource {
  AdminMembersRemoteDataSource(this._network, this._auth);

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

  Future<List<AdminMemberModel>> fetchMembers({
    required bool active,
    bool deleted = false,
  }) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.memberIndex,
        data: <String, dynamic>{
          'filters': <String, dynamic>{'active': active ? 1 : 0},
          'orderBy': 'id',
          'orderByDirection': 'asc',
          'perPage': 100,
          'paginate': true,
          'delete': deleted,
        },
        options: _authOptions,
      );
      final body = res.data;
      if (body == null || body['data'] is! List) return [];
      return (body['data'] as List)
          .whereType<Map>()
          .map((e) => AdminMemberModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<AdminMemberModel> fetchMemberDetails(int memberId) async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        '${ApiEndpoints.member}/$memberId',
        options: _authOptions,
      );
      final body = res.data;
      if (body == null || body['data'] is! Map<String, dynamic>) {
        throw Exception('Invalid member details response');
      }
      return AdminMemberModel.fromJson(body['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> deleteMembers(List<int> ids) async {
    try {
      await _network.client.delete<Map<String, dynamic>>(
        ApiEndpoints.memberDelete,
        data: <String, dynamic>{'ids': ids},
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> toggleActive(int memberId) async {
    try {
      await _network.client.put<Map<String, dynamic>>(
        '${ApiEndpoints.member}/$memberId/active',
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> toggleDead(int memberId) async {
    try {
      await _network.client.put<Map<String, dynamic>>(
        '${ApiEndpoints.member}/$memberId/dead',
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
