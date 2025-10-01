import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../models/login_model.dart';

class AuthRepository {
  final Dio _dio = ApiClient().dio;

  Future<LoginModel> login(String username, String password) async {
    try {
      final formData = FormData.fromMap({
        "username": username,
        "password": password,
      });

      final response = await _dio.post("Login", data: formData);

      if (response.data is Map<String, dynamic>) {
        return LoginModel.fromJson(response.data);
      } else {
        return LoginModel.fromJson(Map<String, dynamic>.from(response.data));
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
