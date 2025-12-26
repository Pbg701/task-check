import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_task_checkin_app/presentation/admin/admin_controller.dart';
import 'package:offline_task_checkin_app/presentation/checkin/checkin_controller.dart';
import 'core/services/init_service.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyALVYX9vYLwviX1VCP-KfwOZ6jjFgL6qX4",
      appId: "1:951618252568:android:2b10ecbf01d911a2eaf86d",
      messagingSenderId: "951618252568",
      projectId: "task-check-9712e",
    ),
  );
  await InitService.init(); // Firebase, Hive, others
  Get.lazyPut(() => AdminController());
  Get.lazyPut<CheckinController>(
    () => CheckinController(),
    fenix: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Task & Check-in',
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      locale: const Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      defaultTransition: Transition.rightToLeftWithFade,
    );
  }
}
