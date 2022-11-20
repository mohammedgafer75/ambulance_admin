import 'package:ambulance_admin/screens/AdminPage/new_admin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:ambulance_admin/controller/auth_controller.dart';

class Admins extends StatelessWidget {
  const Admins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find();
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admins'),
        actions: [
          IconButton(
              onPressed: () {
                controller.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NewAdminPage());
        },
        child: const Icon(Icons.add),
      ),
      body: GetX<AuthController>(
        autoRemove: false,
        builder: (logic) {
          return SizedBox(
            height: data.size.height,
            width: data.size.width,
            child: Stack(children: [
              logic.admins.isEmpty
                  ? const Center(
                      child: Text('No Admins Founded'),
                    )
                  : ListView.builder(
                      itemCount: logic.admins.length,
                      itemBuilder: (BuildContext context, int index) {
                        return logic.admins[index].name == 'admin'
                            ? SizedBox()
                            : Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text('${logic.admins[index].name}'),
                                  leading: CircleAvatar(
                                    child: Text('${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  subtitle: Text(
                                      'email: ${logic.admins[index].email}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                                      IconButton(
                                        onPressed: () {
                                          logic.deleteAdmin(
                                              logic.admins[index].id!);
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
