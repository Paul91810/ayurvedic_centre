import 'package:ayurvedic_centre/data/models/patient_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/repositories/patient_repository.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientRepository _repo = PatientRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Patient> _patients = [];
  List<Patient> _displayPatients = [];
  List<Patient> get patients => _displayPatients;

  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String _sortBy = "Name"; // default
  String get sortBy => _sortBy;

  Future<void> loadPatients({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _patients = [];
      _displayPatients = [];
      _page = 1;
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final patientList =
          await _repo.fetchPatients(page: _page, pageSize: _pageSize);
      final newPatients = patientList.patient ?? [];

      if (newPatients.isEmpty) {
        _hasMore = false;
      } else {
        _patients.addAll(newPatients);
        _page++;
      }

      _applyFilters();
    } catch (e) {
      debugPrint("Error fetching patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearch(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setSortBy(String value) {
    _sortBy = value;
    _applyFilters();
  }

  void _applyFilters() {
    var list = _patients.where((p) {
      final name = (p.name ?? "").toLowerCase();
      final phone = (p.phone ?? "").toLowerCase();
      return name.contains(_searchQuery) || phone.contains(_searchQuery);
    }).toList();

    if (_sortBy == "Name") {
      list.sort((a, b) {
        final nameA =
            (a.name == null || a.name!.trim().isEmpty) ? "zzzz" : a.name!.toLowerCase();
        final nameB =
            (b.name == null || b.name!.trim().isEmpty) ? "zzzz" : b.name!.toLowerCase();
        return nameA.compareTo(nameB);
      });
    } else if (_sortBy == "Date") {
      list.sort((a, b) {
        final aDate = _parseDate(a.dateNdTime);
        final bDate = _parseDate(b.dateNdTime);
        return bDate.compareTo(aDate); // newest first
      });
    }

    _displayPatients = list;
    notifyListeners();
  }

  DateTime _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime(1900);
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return DateTime(1900);
    }
  }

  String formatDate(String? raw) {
    final date = _parseDate(raw);
    if (date.year == 1900) return "-";
    return DateFormat("dd MMM yyyy, hh:mm a").format(date);
  }
}
