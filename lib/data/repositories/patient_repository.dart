import 'package:ayurvedic_centre/data/models/patient_list.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class PatientRepository {
  final Dio _dio = ApiClient().dio;

  Future<PatientListModel> fetchPatients({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _dio.get(
        "PatientList",
        queryParameters: {
          "page": page,
          "page_size": pageSize,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return PatientListModel.fromJson(response.data);
      } else {
        return PatientListModel.fromJson(Map<String, dynamic>.from(response.data));
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
