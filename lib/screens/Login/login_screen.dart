import 'package:ambulance_admin/Animation/FadeAnimation.dart';
import 'package:ambulance_admin/screens/DriverPages/driver_page.dart';
import 'package:ambulance_admin/screens/AdminPage/hospital_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Components/custom_textfield.dart';
import '../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, required this.ch}) : super(key: key);
  final ch;
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage('assets/images/background.png'),
                  //         fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png'))),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/clock.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8.0),
                              ),
                              CustomTextField(
                                  bol: false,
                                  controller: controller.email,
                                  validator: (validator) {
                                    return controller.validateEmail(validator!);
                                  },
                                  lable: 'Email',
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.indigo,
                                  ),
                                  input: TextInputType.emailAddress),
                              SizedBox(
                                height: 40,
                              ),
                              CustomTextField(
                                  bol: true,
                                  controller: controller.password,
                                  validator: (validator) {
                                    return controller
                                        .validatePassword(validator!);
                                  },
                                  lable: 'Password',
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.indigo,
                                  ),
                                  input: TextInputType.text),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                if (ch == 1) {
                                  controller.login(1);
                                }
                                if (ch == 2) {
                                  controller.login(2);
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
