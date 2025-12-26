// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:offline_task_checkin_app/data/local/hive_service.dart';
// import 'package:offline_task_checkin_app/presentation/auth/auth_controller.dart';
// import 'connectivity_service.dart';

// class InitService {
//   static Future<void> init() async {
//     await Hive.initFlutter();
//     await HiveService.registerAdapters();
//     print('[InitService] Hive adapters registered!');
//     Get.put(AuthController(), permanent: true);

//     // Register your global services
//     Get.put<ConnectivityService>(
//       ConnectivityService(),
//       permanent: true,
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:offline_task_checkin_app/data/local/hive_service.dart';
import 'package:offline_task_checkin_app/data/models/user_model.dart';
import 'package:offline_task_checkin_app/presentation/auth/auth_controller.dart';
import 'connectivity_service.dart';

class InitService {
  static Future<void> init() async {

    // INIT HIVE

    await Hive.initFlutter();
    await HiveService.registerAdapters();

    //  OPEN REQUIRED BOXES (CRITICAL)
    await Hive.openBox<UserModel>('userBox');

    print('[InitService] Hive initialized & boxes opened');

    // GLOBAL CONTROLLERS

    Get.put<AuthController>(
      AuthController(),
      permanent: true,
    );

    Get.put<ConnectivityService>(
      ConnectivityService(),
      permanent: true,
    );
  }
}
