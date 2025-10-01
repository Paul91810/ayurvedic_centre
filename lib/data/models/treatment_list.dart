class TreatmentListModel {
  bool? status;
  String? message;
  List<Treatments>? treatments;

  TreatmentListModel({this.status, this.message, this.treatments});

  TreatmentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['treatments'] != null) {
      treatments = <Treatments>[];
      json['treatments'].forEach((v) {
        treatments!.add(new Treatments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.treatments != null) {
      data['treatments'] = this.treatments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Treatments {
  int? id;
  List<Branches>? branches;
  String? name;
  String? duration;
  String? price;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Treatments(
      {this.id,
      this.branches,
      this.name,
      this.duration,
      this.price,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  Treatments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(new Branches.fromJson(v));
      });
    }
    name = json['name'];
    duration = json['duration'];
    price = json['price'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.branches != null) {
      data['branches'] = this.branches!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Branches {
  int? id;
  String? name;
  int? patientsCount;
  String? location;
  String? phone;
  String? mail;
  String? address;
  String? gst;
  bool? isActive;

  Branches(
      {this.id,
      this.name,
      this.patientsCount,
      this.location,
      this.phone,
      this.mail,
      this.address,
      this.gst,
      this.isActive});

  Branches.fromJson(Map<String, dynamic> json) {
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
