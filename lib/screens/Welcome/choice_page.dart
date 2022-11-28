import 'package:ambulance_admin/Animation/FadeAnimation.dart';
import 'package:ambulance_admin/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';

import '../DriverPages/driver_page.dart';
import '../AdminPage/hospital_page.dart';

class ChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
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
                            "Role",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // FadeAnimation(
                      //     1.8,
                      //     Container(
                      //       padding: EdgeInsets.all(5),
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(10),
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Color.fromRGBO(143, 148, 251, .2),
                      //                 blurRadius: 20.0,
                      //                 offset: Offset(0, 10))
                      //           ]),
                      //     )),
                      SizedBox(
                        height: 30,
                      ),
                      // FadeAnimation(
                      //     2,
                      //     Container(
                      //       height: 50,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           gradient: LinearGradient(colors: [
                      //             Color.fromRGBO(143, 148, 251, 1),
                      //             Color.fromRGBO(143, 148, 251, .6),
                      //           ])),
                      //       child: Center(
                      //         child: FlatButton(
                      //             onPressed: () {
                      //               Navigator.of(context).push(
                      //                   MaterialPageRoute(
                      //                       builder: (BuildContext context) =>
                      //                           PatientPage()));
                      //             },
                      //             child: Text(
                      //               "User",
                      //               style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.bold),
                      //             )),
                      //       ),
                      //     )),
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen(
                                          ch: 1,
                                        )));
                              },
                              child: Text(
                                "Admin",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen(
                                          ch: 2,
                                        )));
                              },
                              child: Text(
                                "Driver",
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
