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
  String dateNdTime; 
  int? id; 
  String male; 
  String female; 
  int branch; 
  String treatments; 

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
    "id": id == null ? "" : id.toString(),  
    "male": male.isEmpty ? "" : male,        
    "female": female.isEmpty ? "" : female,  
    "branch": branch,                        
    "treatments": treatments.isEmpty ? "" : treatments, 
  };
}

}
