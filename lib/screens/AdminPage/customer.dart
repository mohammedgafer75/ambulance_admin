import 'package:ambulance_admin/screens/AdminPage/new_driver_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:ambulance_admin/controller/auth_controller.dart';

class Customers extends StatelessWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NewDriversCode());
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
              logic.users.isEmpty
                  ? const Center(
                      child: Text('No Users Founded  '),
                    )
                  : ListView.builder(
                      itemCount: logic.users.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text('${logic.users[index].name}'),
                              leading: CircleAvatar(
                                child: Text('${index + 1}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.blueAccent,
                              ),
                              subtitle:
                                  Text('Number: ${logic.users[index].number}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                                  IconButton(
                                    onPressed: () {
                                      logic.deleteCustomer(
                                          logic.users[index].id!);
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
