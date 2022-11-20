import 'dart:io';
import 'dart:typed_data';
import 'package:ambulance_admin/controller/auth_controller.dart';
import 'package:ambulance_admin/screens/AdminPage/admins_page.dart';
import 'package:ambulance_admin/screens/AdminPage/hospital_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class NewAdminPage extends StatefulWidget {
  @override
  _NewDriversCodeState createState() => _NewDriversCodeState();
}

class _NewDriversCodeState extends State<NewAdminPage> {
  AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: RichText(
                    text: TextSpan(
                        text: "Add New Admin",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                        ))),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                      text: "Details",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                      ))),
              SizedBox(
                height: 20,
              ),
              Form(
                  key: controller.formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: RichText(
                            text: TextSpan(
                                text: "Name",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: controller.name,
                        validator: (value) {
                          return controller.validate(value!);
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  width: 2.0),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            hintText: "Admin's Name"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: RichText(
                            text: TextSpan(
                                text: "Admin Email",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: controller.email,
                        validator: (value) {
                          return controller.validateEmail(value!);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  width: 2.0),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            hintText: "Email"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: RichText(
                            text: TextSpan(
                                text: "Admin Password",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: controller.password,
                        validator: (value) {
                          return controller.validatePassword(value!);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  width: 2.0),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            hintText: "Password"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Get.to(() => const Admins());
                    }),
                TextButton(
                    child: Text("Add Admin"),
                    onPressed: () {
                      controller.register(3);
                    })
              ])
            ],
          ),
        ),
      )),
    );
  }
}
