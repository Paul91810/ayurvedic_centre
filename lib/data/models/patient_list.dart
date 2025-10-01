class PatientList {
  bool? status;
  String? message;
  List<Patient>? patient;

  PatientList({this.status, this.message, this.patient});

  PatientList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['patient'] != null) {
      patient = <Patient>[];
      json['patient'].forEach((v) {
        patient!.add(new Patient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.patient != null) {
      data['patient'] = this.patient!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Patient {
  int? id;
  List<PatientdetailsSet>? patientdetailsSet;
  Branch? branch;
  String? user;
  String? payment;
  String? name;
  String? phone;
  String? address;
  Null? price;
  int? totalAmount;
  int? discountAmount;
  int? advanceAmount;
  int? balanceAmount;
  String? dateNdTime;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Patient(
      {this.id,
      this.patientdetailsSet,
      this.branch,
      this.user,
      this.payment,
      this.name,
      this.phone,
      this.address,
      this.price,
      this.totalAmount,
      this.discountAmount,
      this.advanceAmount,
      this.balanceAmount,
      this.dateNdTime,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['patientdetails_set'] != null) {
      patientdetailsSet = <PatientdetailsSet>[];
      json['patientdetails_set'].forEach((v) {
        patientdetailsSet!.add(new PatientdetailsSet.fromJson(v));
      });
    }
    branch =
        json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
    user = json['user'];
    payment = json['payment'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    price = json['price'];
    totalAmount = json['total_amount'];
    discountAmount = json['discount_amount'];
    advanceAmount = json['advance_amount'];
    balanceAmount = json['balance_amount'];
    dateNdTime = json['date_nd_time'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.patientdetailsSet != null) {
      data['patientdetails_set'] =
          this.patientdetailsSet!.map((v) => v.toJson()).toList();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    data['user'] = this.user;
    data['payment'] = this.payment;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['price'] = this.price;
    data['total_amount'] = this.totalAmount;
    data['discount_amount'] = this.discountAmount;
    data['advance_amount'] = this.advanceAmount;
    data['balance_amount'] = this.balanceAmount;
    data['date_nd_time'] = this.dateNdTime;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PatientdetailsSet {
  int? id;
  String? male;
  String? female;
  int? patient;
  int? treatment;
  String? treatmentName;

  PatientdetailsSet(
      {this.id,
      this.male,
      this.female,
      this.patient,
      this.treatment,
      this.treatmentName});

  PatientdetailsSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    male = json['male'];
    female = json['female'];
    patient = json['patient'];
    treatment = json['treatment'];
    treatmentName = json['treatment_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['male'] = this.male;
    data['female'] = this.female;
    data['patient'] = this.patient;
    data['treatment'] = this.treatment;
    data['treatment_name'] = this.treatmentName;
    return data;
  }
}

class Branch {
  int? id;
  String? name;
  int? patientsCount;
  String? location;
  String? phone;
  String? mail;
  String? address;
  String? gst;
  bool? isActive;

  Branch(
      {this.id,
      this.name,
      this.patientsCount,
      this.location,
      this.phone,
      this.mail,
      this.address,
      this.gst,
      this.isActive});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    patientsCount = json['patients_count'];
    location = json['location'];
    phone = json['phone'];
    mail = json['mail'];
    address = json['address'];
    gst = json['gst'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['patients_count'] = this.patientsCount;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['mail'] = this.mail;
    data['address'] = this.address;
    data['gst'] = this.gst;
    data['is_active'] = this.isActive;
    return data;
  }
}
