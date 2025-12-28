import 'package:dio/dio.dart';
import '../core/api_constants.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    // Ensure we are sending JSON
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    // Add User-Agent to avoid 403 blocking on some servers
    _dio.options.headers['User-Agent'] = 'PostmanRuntime/7.29.0';

    // Add logging to help debug if issues persist
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.login}',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.register}',
        data: {'email': email, 'password': password, 'name': name},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }
}
