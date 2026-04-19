import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';

class RequestsRemoteDataSource {
  RequestsRemoteDataSource(this._network, this._auth);

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
        for (final entry in errors.entries) {
          final v = entry.value;
          if (v is List && v.isNotEmpty) {
            return v.first.toString();
          }
          if (v is String && v.isNotEmpty) {
            return v;
          }
        }
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return 'حدث خطأ';
  }

  /// POST /add-member-public
  Future<void> addMemberPublic(Map<String, dynamic> body) async {
    try {
      await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.addMemberPublic,
        data: body,
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
