import 'package:ambulance_admin/Components/loading.dart';
import 'package:ambulance_admin/Components/snackbar.dart';
import 'package:ambulance_admin/model/driver_model.dart';
import 'package:ambulance_admin/model/hospitals.dart';
import 'package:ambulance_admin/model/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loca;
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:geocoding/geocoding.dart';

class ReportController extends GetxController {
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController status, name, hospitalName, location;
  late LatLng mapLocation;
  late int number;
  int ch = 0;
  RxInt num = 0.obs;

  RxList _imageFileList = [].obs;
  RxList images_url = [].obs;

  // Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;
  late CollectionReference driverCollectionReference;
  late CollectionReference hospitalCollectionReference;
  auth.User? user;
  RxList<Reports> reports = RxList<Reports>([]);
  RxList<Drivers> drivers = RxList<Drivers>([]);
  RxList<Hospitals> hospitals = RxList<Hospitals>([]);
  RxList<String> hospitalsName = RxList<String>([]);
  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    super.onInit();
    getLoc();
    status = TextEditingController();
    name = TextEditingController();
    hospitalName = TextEditingController();
    location = TextEditingController();
    // getUserNumber(user!.uid);
    collectionReference = firebaseFirestore.collection("reports");
    driverCollectionReference = firebaseFirestore.collection("driver");
    hospitalCollectionReference = firebaseFirestore.collection("hospitals");
    reports.bindStream(getAllReport());
    drivers.bindStream(getAllDriver());
    hospitals.bindStream(getAllHospitals());
  }

  Stream<List<Reports>> getAllReport() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Reports.fromMap(item)).toList());
  Stream<List<Drivers>> getAllDriver() => driverCollectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Drivers.fromMap(item)).toList());
  Stream<List<Hospitals>> getAllHospitals() =>
      hospitalCollectionReference.snapshots().map((query) =>
          query.docs.map((item) => Hospitals.fromMap(item)).toList());
  getlist() => _imageFileList;
  void clearList() {
    _imageFileList.clear();
    images_url.clear();
  }

  Future getAllHospitalsName() async {
    hospitalsName.clear();
    for (var element in hospitals) {
      hospitalsName.add(element.hopitalName!);
    }
  }

  // Future getUserNumber(String uid) async {
  //   var res = await FirebaseFirestore.instance
  //       .collection("users")
  //       .where('uid', isEqualTo: uid)
  //       .get();
  //   number = int.tryParse(res.docs.first['number'].toString())!;
  // }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "This field can be empty";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "This field can not be empty";
    }
    return null;
  }

  void updateList(String value, RxString type) {
    type.value = value;
  }

  void increment(RxInt type) {
    type.value++;
  }

  void decrement(RxInt type) {
    type.value--;
  }

  late LocationData currentPosition;
  String adress = "";
  loca.Location geolocation = loca.Location();
  Future getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await geolocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await geolocation.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await geolocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await geolocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    currentPosition = await geolocation.getLocation();
    var addresses = await placemarkFromCoordinates(
        currentPosition.latitude!, currentPosition.longitude!,
        localeIdentifier: "en_US");
    Placemark place = addresses[0];
    var Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
    adress = Address;
    update();
    mapLocation = LatLng(currentPosition.latitude!, currentPosition.longitude!);
    return currentPosition;
  }

  late Map<String, dynamic> re;
  void sendReport() async {
    final isValid = formKey2.currentState!.validate();
    if (!isValid) {
      return;
    }
    auth.User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    String? name = user.displayName;
    re = <String, dynamic>{
      "uid": uid,
      "name": name,
      "status": status.text,
      "number": num.value,
      "aprrove": "waiting",
      "by": "",
      "number": 0
    };
    showdilog();
    collectionReference.doc().set(re).whenComplete(() {
      Get.back();
      showbar(
          "Report Added", "Report Added", "Report added successfully", true);
    }).catchError((error) {
      Get.back();
      showbar("Error", "Error", error.toString(), false);
    });
  }

  void addHospital() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    auth.User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    String? name = user.displayName;
    re = <String, dynamic>{
      "hopitalName": hospitalName.text,
      "location": location.text,
    };
    showdilog();
    hospitalCollectionReference.doc().set(re).whenComplete(() {
      Get.back();
      showbar("Hospital Added", "Hospital Added", "Hospital added successfully",
          true);
    }).catchError((error) {
      Get.back();
      showbar("Error", "Error", error.toString(), false);
    });
  }

  void deleteReports(String id) {
    Get.dialog(AlertDialog(
      content: const Text('Report delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await collectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Delete Report', '', 'Room Report', true);
              } catch (e) {
                showbar('Delete Report ', '', e.toString(), false);
                Get.back();
              }
            },
            child: const Text('delete')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }

  void deleteDriver(String id) {
    Get.dialog(AlertDialog(
      content: const Text('Driver delete'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await driverCollectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Delete Driver', '', 'Driver deleted', true);
              } catch (e) {
                showbar('Delete Driver ', '', e.toString(), false);
                Get.back();
              }
            },
            child: const Text('delete')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }

  void deleteHospital(String id) {
    Get.dialog(AlertDialog(
      content: const Text('Driver Hospital'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                await hospitalCollectionReference.doc(id).delete();
                update();
                Get.back();
                Get.back();
                showbar('Hospital Driver', '', 'Hospital deleted', true);
              } catch (e) {
                showbar('Hospital Driver ', '', e.toString(), false);
                Get.back();
              }
            },
            child: const Text('delete')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }
}
