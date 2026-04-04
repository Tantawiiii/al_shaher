import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../../auth/register/data/models/member_model.dart';
import 'member_detail_model.dart';

class MembersRemoteDataSource {
  MembersRemoteDataSource(this._network, this._auth);

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

  Future<List<MemberModel>> fetchMembers() async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.memberIndex,
        data: <String, dynamic>{
          'filters': <String, dynamic>{
            'active': true,
          },
          'orderBy': 'id',
          'orderByDirection': 'asc',
          'perPage': 100,
          'paginate': true,
          'delete': false,
        },
        options: _authOptions,
      );
      final data = res.data;
      if (data == null) return [];
      final raw = data['data'];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(MemberModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<MemberDetailModel> fetchMemberDetails(int memberId) async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        '${ApiEndpoints.member}/$memberId',
        options: _authOptions,
      );
      final data = res.data;
      if (data == null || data['data'] is! Map<String, dynamic>) {
        throw Exception('Invalid member details response');
      }
      return MemberDetailModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
