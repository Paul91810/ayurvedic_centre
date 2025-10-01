// lib/data/repositories/treatment_repository.dart
import 'package:ayurvedic_centre/data/models/treatment_list.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class TreatmentRepository {
  final Dio _dio = ApiClient().dio;

  Future<TreatmentListModel> fetchTreatments() async {
    try {
      final response = await _dio.get("TreatmentList");

      if (response.data is Map<String, dynamic>) {
        return TreatmentListModel.fromJson(response.data);
      } else {
        return TreatmentListModel.fromJson(Map<String, dynamic>.from(response.data));
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
