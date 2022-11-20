import 'package:ambulance_admin/controller/report_controller.dart';
import 'package:ambulance_admin/screens/AdminPage/addHospital.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HospitalManagment extends StatelessWidget {
  const HospitalManagment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals managment'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddHospital());
        },
        child: const Icon(Icons.add),
      ),
      body: GetX<ReportController>(
        autoRemove: false,
        builder: (logic) {
          return SizedBox(
            height: data.size.height,
            width: data.size.width,
            child: Stack(children: [
              logic.hospitals.isEmpty
                  ? const Center(
                      child: Text('No hospitals Founded  '),
                    )
                  : ListView.builder(
                      itemCount: logic.hospitals.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title:
                                  Text('${logic.hospitals[index].hopitalName}'),
                              leading: CircleAvatar(
                                child: Text('${index + 1}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.blueAccent,
                              ),
                              subtitle: Text(
                                  'Location: ${logic.hospitals[index].location}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                                  IconButton(
                                    onPressed: () {
                                      logic.deleteHospital(
                                          logic.hospitals[index].id!);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
            ]),
          );
        },
      ),
    );
  }
}
