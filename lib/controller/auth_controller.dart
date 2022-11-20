import 'dart:math';
import 'package:ambulance_admin/Components/loading.dart';
import 'package:ambulance_admin/screens/AdminPage/main_page.dart';
import 'package:ambulance_admin/screens/Login/login_screen.dart';
import 'package:ambulance_admin/screens/Signup/signup_screen.dart';
import 'package:ambulance_admin/screens/Welcome/welcome_screen.dart';
import 'package:ambulance_admin/screens/DriverPages/driver_page.dart';
import 'package:ambulance_admin/screens/AdminPage/hospital_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/snackbar.dart';
import '../model/admin_model.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late TextEditingController email,
      name,
      password,
      Rpassword,
      repassword,
      years,
      carNumber,
      number;

  bool ob = false;
  bool obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool obscureTextSignupConfirm = true;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  static FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference collectionReference4;
  late CollectionReference collectionReference;
  late CollectionReference adminCollectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxList<Users> users = RxList<Users>([]);
  RxList<Admins> admins = RxList<Admins>([]);
  late Widget route;
  @override
  void onReady() {
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
    super.onReady();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    years = TextEditingController();
    Rpassword = TextEditingController();
    repassword = TextEditingController();
    number = TextEditingController();
    name = TextEditingController();
    carNumber = TextEditingController();
    collectionReference = firebaseFirestore.collection("users");
    adminCollectionReference = firebaseFirestore.collection("admin");
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    users.bindStream(getAllUser());
    admins.bindStream(getAllAdmin());
    // getAllUser();
    ever(_user, _initialScreen);
    super.onInit();
  }

  // Stream<List<Users>> getUser() => collectionReference4
  //     .where('uid', isEqualTo: auth.currentUser!.uid)
  //     .snapshots()
  //     .map((query) => query.docs.map((item) => Users.fromMap(item)).toList());
  Stream<List<Users>> getAllUser() => collectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Users.fromMap(item)).toList());
  Stream<List<Admins>> getAllAdmin() => adminCollectionReference
      .snapshots()
      .map((query) => query.docs.map((item) => Admins.fromMap(item)).toList());
  String? get user_ch => _user.value!.email;
  _initialScreen(User? user) {
    if (user == null) {
      route = WelcomeScreen();
    } else {
      users.bindStream(getAllUser());
      // route = PatientPage();
    }
  }

  late String uid;
  late int phone;
  getUser() async {
    String uid = auth.currentUser!.uid;
    var res = await collectionReference4.where('uid', isEqualTo: uid).get();
    if (res.docs.isNotEmpty) {
      print(res.docs.first['number']);
      phone = res.docs.first['number'];
      uid = res.docs.first['uid'];
    }
  }

  toggleLogin() {
    obscureTextLogin = !obscureTextLogin;

    update(['loginOb']);
  }

  toggleSignup() {
    obscureTextSignup = !obscureTextSignup;
    update(['reOb']);
  }

  toggleSignupConfirm() {
    obscureTextSignupConfirm = !obscureTextSignupConfirm;
    update(['RreOb']);
  }

  String? validate(String value) {
    if (value.isEmpty) {
      return "please enter your name";
    }

    return null;
  }

  String? validateNumber(String value) {
    if (value.isEmpty) {
      return "please enter your Phone";
    }
    if (value.length < 10) {
      return "Phone length must be more than 10";
    }

    return null;
  }

  String? validateCarNumber(String value) {
    if (value.isEmpty) {
      return "please enter your Phone";
    }
    if (value.length < 5) {
      return "Phone length must be more than 4";
    }

    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty) {
      return "please enter your email";
    }

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    return null;
  }

  String? validateRePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    if (password.text != value) {
      return "password not matched ";
    }
    return null;
  }

  changeOb() {
    ob = !ob;
    update(['password']);
  }

  void deleteCustomer(String id) {
    Get.dialog(AlertDialog(
      content: const Text(' delete customer'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                FirebaseFirestore.instance.collection('users').doc(id).delete();
                Get.back();
                Get.back();
                showbar(' delete customer', 'delete customer', ' ', true);
              } catch (e) {
                showbar(
                    'delete customer', 'delete customer', e.toString(), false);
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

  void deleteAdmin(String id) {
    Get.dialog(AlertDialog(
      content: const Text(' delete Admin'),
      actions: [
        TextButton(
            onPressed: () async {
              try {
                showdilog();
                FirebaseFirestore.instance.collection('admin').doc(id).delete();
                Get.back();
                Get.back();
                showbar(' delete admin', 'delete admin', ' ', true);
              } catch (e) {
                showbar('delete admin', 'delete admin', e.toString(), false);
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

  void signOut() async {
    Get.dialog(AlertDialog(
      content: const Text('Are you are sure to log out'),
      actions: [
        TextButton(
            onPressed: () async {
              await auth
                  .signOut()
                  .then((value) => Get.offAll(() => WelcomeScreen()));
            },
            child: const Text('YES')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('BACK'))
      ],
    ));
  }

  void register(int a) async {
    if (formKey2.currentState!.validate()) {
      try {
        showdilog();
        if (a == 1) {
          final credential = await auth.createUserWithEmailAndPassword(
              email: email.text, password: password.text);
          credential.user!.updateDisplayName(name.text);
          await credential.user!.reload();
          await FirebaseFirestore.instance
              .collection('admin')
              .doc(credential.user!.uid)
              .set({
            'name': name.text,
            'email': email.text,
            'approv': 0,
            'uid': credential.user!.uid,
          });
          Get.back();
          email.clear();
          password.clear();
          number.clear();
          name.clear();
          showbar("About User", "User message", "User Created!!", true);
        }
        if (a == 2) {
          final credential = await auth.createUserWithEmailAndPassword(
              email: email.text, password: password.text);
          credential.user!.updateDisplayName(name.text);
          await credential.user!.reload();
          await FirebaseFirestore.instance
              .collection('driver')
              .doc(credential.user!.uid)
              .set({
            'name': name.text,
            'number': int.tryParse(number.text),
            'email': email.text,
            'years': int.tryParse(years.text),
            'uid': credential.user!.uid,
            'carNumber': int.tryParse(carNumber.text),
            'status': 0
          });
          Get.back();
          email.clear();
          password.clear();
          number.clear();
          name.clear();
          years.clear();
          showbar("About Driver", "User message", "Driver Added!!", true);
        }
        if (a == 3) {
          final credential = await auth.createUserWithEmailAndPassword(
              email: email.text, password: password.text);
          credential.user!.updateDisplayName(name.text);
          await credential.user!.reload();
          await FirebaseFirestore.instance
              .collection('admin')
              .doc(credential.user!.uid)
              .set({'name': name.text, 'email': email, 'approv': 1});
          Get.back();
          email.clear();
          password.clear();
          number.clear();
          name.clear();
          years.clear();
          showbar("About admin", "admin message", "admin Added!!", true);
        }
      } on FirebaseAuthException catch (e) {
        Get.back();
        showbar("About admin", "admin message", e.toString(), false);
      }
    }
  }

  void login(int a) async {
    if (formKey.currentState!.validate()) {
      try {
        showdilog();
        if (a == 1) {
          await auth.signInWithEmailAndPassword(
              email: email.text, password: password.text);
          var ch = await FirebaseFirestore.instance
              .collection('admin')
              // .where('aprrov', isEqualTo: 1)
              // .where('email', isEqualTo: email.text)
              .get();
          int approve = 0;
          String? name;
          for (var element in ch.docs) {
            if (element['approv'] == 1 && element['email'] == email.text) {
              approve = 1;
              name = element['name'];
            }
          }
          if (approve == 1) {
            email.clear();
            password.clear();
            Get.back();
            Get.offAll(() => MainPage(
                  name: name!,
                ));
          } else {
            Get.back();
            showbar("About Login", "Login message",
                'You dont have a Entry Permit', false);
          }
        }
        if (a == 2) {
          var ch = await auth.signInWithEmailAndPassword(
              email: email.text, password: password.text);
          await FirebaseFirestore.instance.collection('driver').get();
          String? name = ch.user!.displayName;
          String? id = ch.user!.uid;
          email.clear();
          password.clear();
          Get.back();
          Get.offAll(() => DriverPage(
                name: name!,
                id: id,
              ));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.back();
          showbar("About Login", "Login message",
              "You dont have a Entry Permit", false);
        } else {
          Get.back();
          showbar("About Login", "Login message", e.toString(), false);
        }
      }
    }
  }
}
