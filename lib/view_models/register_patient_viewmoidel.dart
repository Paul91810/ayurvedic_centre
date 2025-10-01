import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/branch_list.dart' as branch_model;
import '../data/models/treatment_list.dart' as treatment_model;
import '../data/repositories/branch_repository.dart';
import '../data/repositories/treatment_repository.dart';
import '../data/repositories/patient_update_repository.dart';
import '../data/models/patient_update_request.dart';

class TreatmentSelection {
  final int id;
  final String name;
  int male;
  int female;

  TreatmentSelection({
    required this.id,
    required this.name,
    this.male = 0,
    this.female = 0,
  });
}

class RegisterPatientViewModel extends ChangeNotifier {
  final BranchRepository _branchRepo = BranchRepository();
  final TreatmentRepository _treatmentRepo = TreatmentRepository();
  final PatientUpdateRepository _updateRepo = PatientUpdateRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isLoadingBranches = false;
  List<branch_model.Branches> branches = [];
  String? selectedBranchId;

  bool isLoadingTreatments = false;
  List<treatment_model.Treatments> treatments = [];

  String? selectedLocation;
  final List<String> locations = ["Kochi", "Trivandrum", "Calicut"];
  String? paymentMode;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<TreatmentSelection> selectedTreatments = [];

  Future<void> fetchBranches() async {
    isLoadingBranches = true;
    notifyListeners();
    try {
      final res = await _branchRepo.fetchBranchList();
      branches = res.branches ?? [];
    } catch (e) {
      branches = [];
      debugPrint("Branch fetch error: $e");
    } finally {
      isLoadingBranches = false;
      notifyListeners();
    }
  }

  Future<void> fetchTreatments() async {
    isLoadingTreatments = true;
    notifyListeners();
    try {
      final res = await _treatmentRepo.fetchTreatments();
      treatments = res.treatments ?? [];
    } catch (e) {
      treatments = [];
      debugPrint("Treatment fetch error: $e");
    } finally {
      isLoadingTreatments = false;
      notifyListeners();
    }
  }

  void setBranch(String? id) {
    selectedBranchId = id;
    notifyListeners();
  }

  void setLocation(String? loc) {
    selectedLocation = loc;
    notifyListeners();
  }

  void setPayment(String mode) {
    paymentMode = mode;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void addTreatment(int id, String name, int male, int female) {
    final existing = selectedTreatments.where((t) => t.id == id).toList();
    if (existing.isEmpty) {
      selectedTreatments.add(
        TreatmentSelection(id: id, name: name, male: male, female: female),
      );
    } else {
      existing.first.male = male;
      existing.first.female = female;
    }
    notifyListeners();
  }

  void removeTreatment(int id) {
    selectedTreatments.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  String _maleIds() => selectedTreatments
      .where((t) => t.male > 0)
      .map((t) => t.id.toString())
      .join(",");
  String _femaleIds() => selectedTreatments
      .where((t) => t.female > 0)
      .map((t) => t.id.toString())
      .join(",");
  String _allTreatmentIds() =>
      selectedTreatments.map((t) => t.id.toString()).join(",");

  String _formatDateTimeForApi(BuildContext context) {
    if (selectedDate == null || selectedTime == null) return "";
    final dateStr = DateFormat("dd/MM/yyyy").format(selectedDate!);
    final timeStr = selectedTime!.format(context);
    return "$dateStr-$timeStr";
  }

  Future<bool> savePatient({
    required BuildContext context,
    required String name,
    required String executive,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final req = PatientUpdateRequest(
        name: name,
        excecutive: executive,
        payment: paymentMode ?? "Cash",
        phone: phone,
        address: address,
        totalAmount: totalAmount,
        discountAmount: discountAmount,
        advanceAmount: advanceAmount,
        balanceAmount: balanceAmount,
        dateNdTime: _formatDateTimeForApi(context),
        id: null,
        male: _maleIds(),
        female: _femaleIds(),
        branch: int.tryParse(selectedBranchId ?? "0") ?? 0,
        treatments: _allTreatmentIds(),
      );

      final res = await _updateRepo.registerOrUpdatePatient(req);

      if (res["status"] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final message = "Failed to register patient";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint("Save patient error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving patient"),
          backgroundColor: Colors.red,
        ),
      );
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
