import 'package:dio/dio.dart';
import '../core/api_constants.dart';
import '../models/category.dart';

class CategoryService {
  final Dio _dio = Dio();

  CategoryService() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['User-Agent'] = 'PostmanRuntime/7.29.0';

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Future<List<Category>> getCategories(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.categories}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Category.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
