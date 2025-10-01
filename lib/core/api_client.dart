// lib/core/api_client.dart
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://flutter-amr.noviindus.in/api/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      try {
        if (Hive.isBoxOpen('settings')) {
          final box = Hive.box('settings');
          final token = box.get('token');
          if (token != null && token.toString().isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
      } catch (_) {}
      return handler.next(options);
    }));
  }

  /// Call this in your app after login if you want to re-initialize headers (optional)
  void init() {
    // noop: instance already has interceptors reading Hive
  }
}
