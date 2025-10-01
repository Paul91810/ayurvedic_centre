// lib/view_models/register_patient_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/patient_list.dart';
import '../data/models/branch_list.dart' as branch_model;
import '../data/models/treatment_list.dart' as treatment_model;
import '../data/repositories/patient_repository.dart';
import '../data/repositories/branch_repository.dart';
import '../data/repositories/treatment_repository.dart';

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
  final PatientRepository _repo = PatientRepository();
  final BranchRepository _branchRepo = BranchRepository();
  final TreatmentRepository _treatmentRepo = TreatmentRepository();

  // patient list / pagination (kept if you need it)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Branches & Treatments (fetched from API)
  bool isLoadingBranches = false;
  List<branch_model.Branches> branches = [];
  String? selectedBranchId;

  bool isLoadingTreatments = false;
  List<treatment_model.Treatments> treatments = [];

  // Form state
  String? selectedLocation;
  final List<String> locations = ["Kochi", "Trivandrum", "Calicut"];
  String? paymentMode; // "Cash" | "Card" | "UPI"
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Selected treatments
  List<TreatmentSelection> selectedTreatments = [];

  // --- fetchers
  Future<void> fetchBranches() async {
    isLoadingBranches = true;
    notifyListeners();
    try {
      final res = await _branchRepo.fetchBranchList();
      branches = res.branches ?? [];
    } catch (e) {
      debugPrint("Branch fetch error: $e");
      branches = [];
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
      debugPrint("Treatment fetch error: $e");
      treatments = [];
    } finally {
      isLoadingTreatments = false;
      notifyListeners();
    }
  }

  // --- form setters
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

  // --- treatments
  void addTreatment(int id, String name, int male, int female) {
    final existing = selectedTreatments.where((t) => t.id == id).toList();
    if (existing.isEmpty) {
      selectedTreatments.add(TreatmentSelection(id: id, name: name, male: male, female: female));
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

  // helpers to build API strings
  String _joinIdsWhereMaleGreaterThanZero() {
    final ids = selectedTreatments.where((t) => t.male > 0).map((t) => t.id.toString()).toList();
    return ids.join(",");
  }

  String _joinIdsWhereFemaleGreaterThanZero() {
    final ids = selectedTreatments.where((t) => t.female > 0).map((t) => t.id.toString()).toList();
    return ids.join(",");
  }

  String _joinAllTreatmentIds() {
    final ids = selectedTreatments.map((t) => t.id.toString()).toList();
    return ids.join(",");
  }

  String _formatDateTimeForApi(BuildContext context) {
    if (selectedDate == null || selectedTime == null) return "";
    final dateStr = DateFormat("dd/MM/yyyy").format(selectedDate!);
    final timeStr = selectedTime!.format(context); // e.g. "10:24 AM"
    // API example you gave: "01/02/2024-10:24 AM"
    return "$dateStr-$timeStr";
  }

  /// Save patient to API (PatientUpdate)
  Future<bool> savePatient({
    required BuildContext context,
    required String name,
    required String executive,
    required String payment,
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
      final form = <String, dynamic>{
        "name": name,
        "excecutive": executive,
        "payment": payment,
        "phone": phone,
        "address": address,
        "total_amount": totalAmount,
        "discount_amount": discountAmount,
        "advance_amount": advanceAmount,
        "balance_amount": balanceAmount,
        "date_nd_time": _formatDateTimeForApi(context),
        "id": "",
        "male": _joinIdsWhereMaleGreaterThanZero(),
        "female": _joinIdsWhereFemaleGreaterThanZero(),
        "branch": selectedBranchId ?? "",
        "treatments": _joinAllTreatmentIds(),
      };

      await _repo.fetchPatients(); // expects this method in PatientRepository

      // Optional: you can generate pdf here if needed (we're focusing on UI)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Patient registered successfully")));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Save patient error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving patient: $e")));
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
