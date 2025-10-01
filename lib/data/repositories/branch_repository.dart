import 'package:ayurvedic_centre/data/models/branch_list.dart';
import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class BranchRepository {
  final Dio _dio = ApiClient().dio;

  Future<BranchListModel> fetchBranchList() async {
    try {
      final response = await _dio.get("BranchList",options: Options(
        headers: {"Cache-Control": "no-cache"},
      ),);

      if (response.data is Map<String, dynamic>) {
        return BranchListModel.fromJson(response.data);
      } else {
        return BranchListModel.fromJson(Map<String, dynamic>.from(response.data));
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
