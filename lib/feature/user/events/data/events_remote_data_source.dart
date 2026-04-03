import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/auth_local_storage.dart';
import 'event_model.dart';

class EventsRemoteDataSource {
  EventsRemoteDataSource(this._network, this._auth);

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

  /// POST /event/index — fetch paginated event list
  Future<List<EventModel>> fetchEvents({int page = 1}) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.eventIndex,
        queryParameters: {'page': page},
        options: _authOptions,
      );
      final data = res.data;
      if (data == null) return [];
      final raw = data['data'];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(EventModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  /// GET /event/{id} — fetch event details
  Future<EventModel> fetchEventDetails(int eventId) async {
    try {
      final res = await _network.client.get<Map<String, dynamic>>(
        '${ApiEndpoints.event}/$eventId',
        options: _authOptions,
      );
      final data = res.data;
      if (data == null || data['data'] is! Map<String, dynamic>) {
        throw Exception('Invalid event details response');
      }
      return EventModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  /// POST /event — create event
  Future<void> createEvent({
    required String name,
    required String description,
    required String date,
    required String time,
    required String location,
    String? lat,
    String? lng,
  }) async {
    try {
      await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.event,
        data: {
          'name': name,
          'description': description,
          'date': date,
          'time': time,
          'location': location,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
        },
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  /// PATCH /event/{id} — update event
  Future<void> updateEvent({
    required int eventId,
    required String name,
    required String description,
    required String date,
    required String time,
    required String location,
    String? lat,
    String? lng,
  }) async {
    try {
      await _network.client.patch<Map<String, dynamic>>(
        '${ApiEndpoints.event}/$eventId',
        data: {
          'name': name,
          'description': description,
          'date': date,
          'time': time,
          'location': location,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
        },
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  /// DELETE /event/delete — delete events
  Future<void> deleteEvents(List<int> ids) async {
    try {
      await _network.client.delete<Map<String, dynamic>>(
        ApiEndpoints.eventDelete,
        data: {'ids': ids},
        options: _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }

  /// POST /event-attendance — record attendance
  Future<String> recordAttendance({
    required int eventId,
    required String status,
    String? note,
  }) async {
    try {
      final res = await _network.client.post<Map<String, dynamic>>(
        ApiEndpoints.eventAttendance,
        data: {
          'event_id': eventId,
          'status': status,
          if (note != null && note.isNotEmpty) 'note': note,
        },
        options: _authOptions,
      );
      final data = res.data;
      return data?['data']?['my_attendance']?.toString() ?? status;
    } on DioException catch (e) {
      throw Exception(_messageFromDio(e));
    }
  }
}
