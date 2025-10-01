import 'dart:developer';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../models/patient_update_request.dart';

class PatientUpdateRepository {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> registerOrUpdatePatient(
    PatientUpdateRequest request,
  ) async {
    log("Saving patient with payload: ${request.toJson()}");

    try {
      final response = await _dio.post(
        "PatientUpdate",
        data: FormData.fromMap(request.toJson()),
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.data is Map<String, dynamic>) {
        log("PatientUpdate response: ${response.data}");
        return Map<String, dynamic>.from(response.data);
      } else {
        return {"status": false, "message": "Unexpected server response"};
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return {"status": false, "message": data['message']};
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
