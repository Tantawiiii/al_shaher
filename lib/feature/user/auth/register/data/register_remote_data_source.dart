import 'package:dio/dio.dart';


import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_service.dart';
import '../../login/data/login_response.dart';
import 'models/branch_model.dart';
import 'models/member_model.dart';

class RegisterRemoteDataSource {
  RegisterRemoteDataSource(this._network);

  final NetworkService _network;

  String _messageFromResponse(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return 'حدث خطأ';
  }

  String _messageFromDio(DioException e) {
    final data = e.response?.data;
    return _messageFromResponse(data);
  }

  Future<LoginResponse> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: <String, dynamic>{
          'phone': phone,
          'password': password,
        },
      );
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw Exception(_messageFromResponse(data));
      }
      return LoginResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    } on FormatException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<int> uploadMedia(String filePath) async {
    final fileName = filePath.split(RegExp(r'[/\\]')).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.media,
        data: formData,
      );
      final data = res.data;
      if (data == null) throw Exception(_messageFromResponse(null));
      final inner = data['data'];
      if (inner is Map<String, dynamic> && inner['id'] != null) {
        return (inner['id'] as num).toInt();
      }
      throw Exception(_messageFromResponse(data));
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<List<BranchModel>> fetchBranches() async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.branchIndex,
        data: <String, dynamic>{},
      );
      final data = res.data;
      if (data == null) return [];
      final raw = data['data'];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(BranchModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<List<MemberModel>> fetchMembersForBranch(int branchId) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.memberIndex,
        data: <String, dynamic>{
          'filters': <String, dynamic>{
            'active': true,
            'branch_id': branchId,
          },
          'orderBy': 'id',
          'orderByDirection': 'asc',
          'perPage': 100,
          'paginate': true,
          'delete': false,
        },
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

  Future<void> submitApplicationForm({
    required String name,
    required String nationalId,
    required String phone,
    String? dateOfBirth,
    required String city,
    required String password,
    required int branchId,
    required int fatherId,
    String? gender,
    required List<String> personalRelationships,
    required int imageId,
  }) async
  {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.applicationForm,
        data: <String, dynamic>{
          'name': name,
          'national_id': nationalId,
          'phone': phone,
          if (dateOfBirth != null && dateOfBirth.isNotEmpty)
            'date_of_birth': dateOfBirth,
          'city': city,
          'password': password,
          'branch_id': branchId,
          'father_id': fatherId,
          if (gender != null && gender.isNotEmpty) 'gender': gender,
          'personal_relationships': personalRelationships,
          'image': imageId,
        },
      );
      final data = res.data;
      final status = data?['status'];
      final result = data?['result']?.toString().toLowerCase();
      final ok = status == 200 ||
          status == '200' ||
          result == 'success';
      if (!ok) {
        throw Exception(_messageFromResponse(data));
      }
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }


}
