import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import 'auth_user_model.dart';
import 'tree_member_model.dart';

class TreeRemoteDataSource {
  TreeRemoteDataSource(this._network, this._auth);

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

  /// GET /members/tree
  Future<List<TreeMemberModel>> fetchTree() async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        ApiEndpoints.membersTree,
        options: _authOptions,
      );
      final data = res.data;
      if (data == null) return [];
      final raw = data['data'];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(TreeMemberModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  /// GET /check-auth
  Future<AuthUserModel> fetchCurrentUser() async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        ApiEndpoints.checkAuth,
        options: _authOptions,
      );
      final data = res.data;
      if (data == null || data['data'] is! Map<String, dynamic>) {
        throw Exception('Invalid check-auth response');
      }
      return AuthUserModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
