import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import 'news_model.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource(this._network, this._auth);

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

  Future<List<NewsModel>> fetchNews({int page = 1}) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.newsIndex,
        queryParameters: {'page': page},
        options: _authOptions,
      );
      final data = res.data;
      if (data == null) return [];
      final raw = data['data'];
      if (raw is! List) return [];
      return raw
          .whereType<Map>()
          .map((e) => NewsModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<NewsModel> fetchNewsDetails(int newsId) async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        '${ApiEndpoints.news}/$newsId',
        options: _authOptions,
      );
      final data = res.data;
      final payload = data?['data'];
      if (payload is! Map) {
        throw Exception('Invalid news details response');
      }
      return NewsModel.fromJson(Map<String, dynamic>.from(payload));
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> createNews({
    required String title,
    required String summary,
    required String content,
    required List<int> galleryIds,
  }) async {
    try {
      await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.news,
        data: {
          'title': title,
          'summary': summary,
          'content': content,
          'gallery': galleryIds,
        },
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> updateNews({
    required int newsId,
    required String title,
    required String summary,
    required String content,
    required List<int> galleryIds,
  }) async {
    try {
      await _network.client.patch<Map<String, dynamic>>(
        '${ApiEndpoints.news}/$newsId',
        data: {
          'title': title,
          'summary': summary,
          'content': content,
          'gallery': galleryIds,
        },
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<void> deleteNews(List<int> ids) async {
    try {
      await _network.client.delete<Map<String, dynamic>>(
        ApiEndpoints.newsDelete,
        data: {'ids': ids},
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  Future<int> uploadMedia(String filePath) async {
    final fileName = filePath.split(RegExp(r'[/\\]')).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.media,
        data: formData,
        options: _authOptions,
      );
      final data = res.data;
      if (data == null) throw Exception('فشل رفع الصورة');
      final inner = data['data'];
      if (inner is Map<String, dynamic> && inner['id'] != null) {
        return (inner['id'] as num).toInt();
      }
      throw Exception('فشل رفع الصورة');
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
