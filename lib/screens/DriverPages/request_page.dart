import 'package:ambulance_admin/Components/loading.dart';
import 'package:ambulance_admin/controller/report_controller.dart';
import 'package:ambulance_admin/screens/DriverPages/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key? key}) : super(key: key);

  @override
  _UserProgressPage createState() => _UserProgressPage();
}

class _UserProgressPage extends State<RequestPage> {
  ReportController controller = Get.find();
  TextEditingController hosName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    hosName.text = controller.hospitalsName[0];
    auth.User? user = FirebaseAuth.instance.currentUser;
    String? name = user!.displayName;
    String? id = user.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Page'),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reports')
              .where('approve', isEqualTo: 'waiting')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No available request ',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: SizedBox(
                            height: 350,
                            width: 70,
                            child: ListView(children: [
                              Center(
                                child: Text(
                                  '${snapshot.data!.docs[index]['status']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Owner Request: ${snapshot.data!.docs[index]['name']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(top: 18, left: 18),
                              //   child: Text(
                              //       'Price: ${snapshot.data!.docs[index]['price']}',
                              //       style: const TextStyle(
                              //           fontSize: 14, color: Colors.black)),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Information: ${snapshot.data!.docs[index]['status']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Number Of Patient: ${snapshot.data!.docs[index]['number']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Row(
                                  children: [
                                    Text(
                                        'Patient Number: ${snapshot.data!.docs[index]['paNumber']}',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black)),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Uri tel = Uri(
                                              scheme: 'tel',
                                              path:
                                                  '${snapshot.data!.docs[index]['paNumber']}');
                                          launchUrl(tel);
                                        },
                                        icon: Icon(Icons.call))
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Location: ${snapshot.data!.docs[index]['address']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownSearch<String>(
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelStyle: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                            labelText: "hospitals name:",
                                            hintText: "select hospitals name",
                                          ),
                                        ),
//                                  mode: Mode.BOTTOM_SHEET,
//                                  showSelectedItems: true,
                                        items: controller.hospitalsName,
//                                  dropdownSearchDecoration:
//
                                        onChanged: (value) {
                                          hosName.text = value!;
                                        },
                                        selectedItem:
                                            controller.hospitalsName[0],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data!.docs[index]['approve'] == 'waiting'
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.only(top: 18, left: 18),
                                      child: Text('Status: waiting',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    )
                                  : snapshot.data!.docs[index]['status'] ==
                                          'accept'
                                      ? const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18, left: 18),
                                          child: Text('Status: Done',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18, left: 18),
                                          child: Text('Status: Cancled',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    snapshot.data!.docs[index]['status'] == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty.all(
                                                            const EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 15,
                                                                right: 15)),
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            const Color.fromRGBO(
                                                                19, 26, 44, 1.0)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(13),
                                                            side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              MapPage(
                                                                  id: snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id,
                                                                  loaction: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'location'])));
                                                },
                                                child: const Text(
                                                  'Open in Map',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 15,
                                                          right: 15)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.indigo),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      side: const BorderSide(color: Colors.indigo)))),
                                          onPressed: () async {
                                            setState(() {
                                              showdilog();
                                            });
                                            try {
                                              var res = await FirebaseFirestore
                                                  .instance
                                                  .collection('driver')
                                                  .doc(id)
                                                  .get();
                                              // print(id);
                                              print('hii' +
                                                  res['number'].toString());
                                              await FirebaseFirestore.instance
                                                  .collection('reports')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .update({
                                                'approve': 'accept',
                                                'driverId': id,
                                                'by': name,
                                                'paNumber': snapshot.data!
                                                    .docs[index]['number'],
                                                'driverNumber': res['number'],
                                                "hospitalName": hosName.text,
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection('driver')
                                                  .doc(id)
                                                  .update({
                                                'status': 3,
                                              });
                                              setState(() {
                                                Get.back();
                                                showBar(context, "accepted", 1);
                                              });
                                            } catch (e) {
                                              setState(() {
                                                Get.back();
                                                showBar(
                                                    context, e.toString(), 0);
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Accept',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  ])
                            ]),
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
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
}
