import 'package:cloud_firestore/cloud_firestore.dart';

class Drivers {
  String? id;
  String? uid;
  String? name;
  String? email;
  int? number;
  int? status;
  int? carNumber;
  int? years;

  Drivers({
    this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.number,
    required this.status,
    required this.carNumber,
    required this.years,
  });

  Drivers.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    email = data["email"];
    status = data["status"];
    number = data["number"];
    years = data["years"];
    carNumber = data["carNumber"];
    uid = data["uid"];
  }
}
