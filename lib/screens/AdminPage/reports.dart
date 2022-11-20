import 'package:ambulance_admin/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Page '),
      ),
      body: GetX<ReportController>(
        autoRemove: false,
        builder: (logic) {
          return SizedBox(
            height: data.size.height,
            width: data.size.width,
            child: Stack(children: [
              logic.reports.isEmpty
                  ? const Center(
                      child: Text('no data founded'),
                    )
                  : ListView.builder(
                      itemCount: logic.reports.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text('${logic.reports[index].name}'),
                              leading: CircleAvatar(
                                child: Text('${index + 1}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor: Colors.blueAccent,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  logic.deleteReports(logic.reports[index].id!);
                                  setState(() {});
                                },
                                color: Colors.red,
                              ),
                              subtitle: Column(
                                children: [
                                  Text(
                                      'description: ${logic.reports[index].status}',
                                      style: const TextStyle(fontSize: 16)),
                                  Text(
                                      'status: ${logic.reports[index].approve}',
                                      style: const TextStyle(fontSize: 16)),
                                  logic.reports[index].approve == 'waiting'
                                      ? const SizedBox()
                                      : Column(
                                          children: [
                                            Text(
                                                'accept by: + ${logic.reports[index].by} ',
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            Text(
                                                '${logic.reports[index].driverNumber} ',
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ],
                                        )
                                ],
                              ),
                              // trailing: Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     // IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                              //     IconButton(
                              //       onPressed: () {
                              //         // logic.deleteCustomer(
                              //         //     logic.users[index].id!);
                              //       },
                              //       icon: const Icon(Icons.delete),
                              //       color: Colors.red,
                              //     ),
                              //   ],
                              // ),
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
