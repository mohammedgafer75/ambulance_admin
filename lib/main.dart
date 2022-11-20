import 'package:ambulance_admin/controller/report_controller.dart';
import 'package:ambulance_admin/controller/setting_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/auth_controller.dart';
import 'screens/Welcome/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  Get.put(ReportController());
  Get.put(SettingController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ambulance App',
      theme: ThemeData(
        // scaffoldBackgroundColor: bgColor,
        primarySwatch: Colors.indigo,
        fontFamily: "Gordita",
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        // textTheme: const TextTheme(
        //   bodyText2: TextStyle(color: Colors.black54),
        // ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
