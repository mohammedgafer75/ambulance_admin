import 'package:ambulance_admin/controller/auth_controller.dart';
import 'package:ambulance_admin/controller/report_controller.dart';
import 'package:ambulance_admin/model/driver_model.dart';
import 'package:ambulance_admin/screens/AdminPage/hospital_managment.dart';
import 'package:ambulance_admin/screens/AdminPage/new_driver_page.dart';
import 'package:ambulance_admin/screens/AdminPage/reports.dart';
import 'package:ambulance_admin/services/drivers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:search_page/search_page.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({Key? key}) : super(key: key);

  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  AuthController controller = Get.find();
  ReportController controller2 = Get.find();
  @override
  Widget build(BuildContext context) {
    List<List<Widget>> tab_cats = sortDrivers();
    print(tab_cats);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<Drivers>(
              searchStyle: const TextStyle(
                  color: Colors.green, backgroundColor: Colors.black),
              items: controller2.drivers,
              searchLabel: 'Search Driver',
              suggestion: const Center(
                child: Text('Filter Driver by name, carNumber '),
              ),
              failure: const Center(
                child: Text('No Driver found :('),
              ),
              filter: (driver) => [
                driver.name,
                driver.carNumber.toString(),
              ],
              builder: (driver) => ListTile(
                onTap: () {
                  // Get.to(() => SearchResult(
                  //       data: person,
                  //     ));
                },
                title: Text('name: ' + driver.name!),
                subtitle: Text('carNumber:  ' + driver.carNumber!.toString()),
                trailing: IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller2.deleteDriver(driver.id!);
                  },
                ),
              ),
            ),
          ),
          child: const Icon(Icons.search),
        ),
        appBar: AppBar(
          // title: Text("All drivers"),
          // backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
          bottom: const TabBar(tabs: [
            const Tab(
              text: "Available",
            ),
            Tab(text: "Working"),
            Tab(text: "Offline"),
          ]),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewDriversCode()),
                    )),
          ],
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              children: tab_cats[0],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: tab_cats[2],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: tab_cats[1],
            ),
          ),
        ]),
      ),
    );
  }

  Widget driverCard(String name, Color col, String status, String number,
      String id, String carNumber) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          // height: MediaQuery.of(context).size.height / 6,
          child: Card(
            child: ListTile(
              title: Text(name),
              subtitle: Column(
                children: [
                  Text('Phone Number: ' + number),
                  Text('Car Number: ' + carNumber),
                ],
              ),
              trailing: IconButton(
                color: Colors.red,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller2.deleteDriver(id);
                  setState(() {});
                },
              ),
            ),
            color: col,
          )),
    );
  }

  List<List<Widget>> sortDrivers() {
    List<List<Widget>> lst = [];
    ReportController controller = Get.find();
    List<Widget> available = [];
    List<Widget> offline = [];
    List<Widget> working = [];

    for (var e in controller.drivers) {
      if (e.status == 0) {
        offline.add(driverCard(
            e.name!,
            const Color.fromRGBO(235, 233, 228, 1),
            "Offline",
            e.number!.toString(),
            e.id!.toString(),
            e.carNumber.toString()));
      } else if (e.status == 1) {
        available.add(driverCard(
            e.name!,
            const Color.fromRGBO(217, 250, 195, 1),
            "Available",
            e.number!.toString(),
            e.id!.toString(),
            e.carNumber.toString()));
      } else if (e.status == 3) {
        working.add(driverCard(
            e.name!,
            const Color.fromRGBO(250, 152, 152, 1),
            "Busy",
            e.number.toString(),
            e.id!.toString(),
            e.carNumber.toString()));
      }
      lst.add(available);
      lst.add(offline);
      lst.add(working);
    }
    return lst;
  }
}
