import 'package:ambulance_admin/Components/custom_button.dart';
import 'package:ambulance_admin/Components/loading.dart';
import 'package:ambulance_admin/controller/auth_controller.dart';
import 'package:ambulance_admin/controller/report_controller.dart';
import 'package:ambulance_admin/controller/setting_controller.dart';
import 'package:ambulance_admin/screens/DriverPages/google_map_page.dart';
import 'package:ambulance_admin/screens/DriverPages/request_page.dart';
import 'package:ambulance_admin/screens/DriverPages/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_badge/icon_badge.dart';

class DriverPage extends StatefulWidget {
  DriverPage({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);
  final String name;
  final String id;
  @override
  _DriverPageState createState() => _DriverPageState();
}

var loc = [];
String currLoc = "";
String address = "";
bool isWorking = false;
bool isAvailable = true;

class _DriverPageState extends State<DriverPage> {
  ReportController controller = Get.find();
  AuthController controller1 = Get.find();
  @override
  void initState() {
    super.initState();
    controller.getAllHospitalsName();
    currentLoc();
  }

  bool ch = false;
  @override
  Widget build(BuildContext context) {
    currentLoc();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver page"),
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        actions: [
          GetBuilder<ReportController>(
            builder: (_) {
              return ch
                  ? IconBadge(
                      icon: const Icon(Icons.notifications_none),
                      itemCount: _.reports.length,
                      badgeColor: Colors.red,
                      itemColor: Colors.white,
                      onTap: () {
                        Get.to(RequestPage());
                      },
                    )
                  : const SizedBox();
            },
          ),
          IconButton(
              onPressed: () {
                controller1.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.put(SettingController());
          Get.to(() => const SettingsPage());
        },
        child: const Icon(Icons.settings_applications),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height / 8,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Image.network(
                                "https://static.wikia.nocookie.net/pokemon/images/8/88/Char-Eevee.png/revision/latest?cb=20190625223735"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Name: ${widget.name}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Available: ",
                    style: const TextStyle(fontSize: 20),
                  ),
                  SlidingSwitch(
                    value: false,
                    width: 200,
                    onChanged: (bool value) async {
                      setState(() {
                        showdilog();
                      });
                      if (value) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('driver')
                              .doc(widget.id)
                              .update({
                            'status': 1,
                          });
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(context,
                                "You'll be notified when we need your help", 1);
                          });
                        } catch (e) {
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(context, e.toString(), 0);
                          });
                        }
                      } else {
                        try {
                          await FirebaseFirestore.instance
                              .collection('driver')
                              .doc(widget.id)
                              .update({
                            'status': 0,
                          });
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(
                                context,
                                "You won't be called for help till you are free",
                                0);
                          });
                        } catch (e) {
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(context, e.toString(), 0);
                          });
                        }
                      }

                      setState(() {
                        ch = value;
                      });
                      // Fluttertoast.showToast(
                      //     msg: !value
                      //         ? "You won't be called for help till you are free"
                      //         : "You'll be notified when we need your help",
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.BOTTOM,
                      //     textColor: Colors.white,
                      //     backgroundColor: !value ? Colors.red : Colors.green,
                      //     fontSize: 16.0);
                    },
                    onDoubleTap: () {},
                    onSwipe: () {},
                    onTap: () {},
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('reports')
                    .where('driverId', isEqualTo: widget.id)
                    .where('approve', isEqualTo: 'accept')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data!.docs.isNotEmpty) {
                      ch = false;
                    }
                    return snapshot.data!.docs.isNotEmpty
                        ? SizedBox(
                            height: 200,
                            child: Column(
                              children: [
                                const Text('You have A patient open map'),
                                CustomTextButton(
                                    lable: 'Open Map',
                                    ontap: () {
                                      Get.to(() => MapPage(
                                          id: widget.id,
                                          loaction: snapshot.data!.docs[0]
                                              ['location']));
                                    },
                                    color: Colors.indigo),
                              ],
                            ),
                          )
                        : const SizedBox();
                  }
                }),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Working: ",
            //       style: TextStyle(fontSize: 28),
            //     ),
            //     SlidingSwitch(
            //       value: false,
            //       width: 200,
            //       onChanged: (bool value) {
            //         isWorking = !value;
            //         if (isWorking) isAvailable = false;
            //         setState(() {
            //           isWorking;
            //           isAvailable;
            //         });
            //       },
            //       onDoubleTap: () {},
            //       onSwipe: () {},
            //       onTap: () {},
            //     ),
            //   ],
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width - 20,
            //   height: MediaQuery.of(context).size.height / 2,
            //   child: !isWorking
            //       ? patientData()
            //       : Card(
            //           child: Image.network(
            //               "https://img.freepik.com/free-vector/lazy-raccoon-sleeping-cartoon_125446-631.jpg?size=338&ext=jpg"),
            //         ),
            // )
          ],
        ),
      ),
    );
  }

  Widget patientData() {
    return GestureDetector(
      onTap: () async {
        currentLoc();

        //address = currLoc.split("{}")[2];
        //loc = currLoc.split("{}")[1].split(" , ");
        address = "Patient's address";
        loc = [0, 0];

        setState(() {
          loc;
          address;
        });
      },
      child: Card(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: const Text(
              "Current Patient",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Image.network(
              "https://www.zyrgon.com/wp-content/uploads/2019/06/googlemaps-Zyrgon.jpg"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(address),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Location: 0, 0"),
          ),
        ],
      )),
    );
  }

  void currentLoc() async {
    // currLoc = await getLoc();
  }
}

void showBar(BuildContext context, String msg, int ch) {
  var bar = SnackBar(
    backgroundColor: ch == 0 ? Colors.red : Colors.green,
    content: Text(msg),
  );
  ScaffoldMessenger.of(context).showSnackBar(bar);
}

showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
        child: SpinKitFadingCube(
          color: Colors.blue,
          size: 50,
        ),
      ),
    ),
  );
}
