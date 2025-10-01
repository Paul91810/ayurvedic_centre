import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final Dio dio = Dio(BaseOptions(
    baseUrl: "https://flutter-amr.noviindus.in/api/",
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  void init() {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final box = Hive.box('app');
          final token = box.get('token');
          if (token != null && token.toString().isNotEmpty) {
            options.headers['Authorization'] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }
}
