import 'package:dio/dio.dart';
import '../core/api_constants.dart';
import '../models/event.dart';

class EventService {
  final Dio _dio = Dio();

  EventService() {
    // Ensure we are sending JSON
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    // Add User-Agent
    _dio.options.headers['User-Agent'] = 'PostmanRuntime/7.29.0';

    // Add logging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<List<Event>> getEvents(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.events}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Event>> getEventsByCategory(int categoryId, String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.events}',
        queryParameters: {'categoryId': categoryId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> registerForEvent(String eventId, String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      // Fixed: Use /api/Registrations/{eventId}
      final response = await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.registrations}/$eventId',
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addReview(
    String eventId,
    int rating,
    String comment,
    String token,
  ) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      // Fixed: Use /api/Reviews with eventId in body
      final response = await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.reviews}',
        data: {
          'eventId': int.parse(eventId),
          'rating': rating,
          'commentText': comment,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }
}
