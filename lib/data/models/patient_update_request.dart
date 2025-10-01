// lib/data/models/patient_update_request.dart
class PatientUpdateRequest {
  String name;
  String excecutive;
  String payment;
  String phone;
  String address;
  double totalAmount;
  double discountAmount;
  double advanceAmount;
  double balanceAmount;
  String dateNdTime; // "dd/MM/yyyy-hh:mm AM"
  int? id; // null for new record -> will be sent as ""
  String male; // "2,3" or "" if none
  String female; // "4,5" or "" if none
  int branch; // branch id (int)
  String treatments; // "2,3,4" or ""

  PatientUpdateRequest({
    required this.name,
    required this.excecutive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    this.id,
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  Map<String, dynamic> toJson() {
  return {
    "name": name,
    "excecutive": excecutive,
    "payment": payment,
    "phone": phone,
    "address": address,
    "total_amount": totalAmount.toInt(),
    "discount_amount": discountAmount.toInt(),
    "advance_amount": advanceAmount.toInt(),
    "balance_amount": balanceAmount.toInt(),
    "date_nd_time": dateNdTime,
    "id": id == null ? "" : id.toString(),   // 🔥 FIXED
    "male": male.isEmpty ? "" : male,        // 🔥 FIXED (string, comma separated)
    "female": female.isEmpty ? "" : female,  // 🔥 FIXED
    "branch": branch,                        // int is OK
    "treatments": treatments.isEmpty ? "" : treatments, // 🔥 FIXED
  };
}

}
