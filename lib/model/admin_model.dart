import 'package:cloud_firestore/cloud_firestore.dart';

class Admins {
  String? id;
  String? name;
  String? email;
  int? approve;

  Admins({
    this.id,
    required this.name,
    required this.email,
    required this.approve,
  });

  Admins.fromMap(DocumentSnapshot data) {
    id = data.id;
    name = data["name"];
    email = data["email"];
    approve = data["approv"];
  }
}
