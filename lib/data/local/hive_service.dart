import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../models/checkin_model.dart';
import '../models/user_model.dart';
import 'hive_boxes.dart';

class HiveService {
  static Future<void> registerAdapters() async {
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(CheckinModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
  }

  static Future<Box<TaskModel>> openTaskBox() async =>
      Hive.openBox<TaskModel>(HiveBoxes.taskBox);
  static Future<Box<CheckinModel>> openCheckinBox() async =>
      Hive.openBox<CheckinModel>(HiveBoxes.checkinBox);
  static Future<Box<UserModel>> openUserBox() async =>
      Hive.openBox<UserModel>(HiveBoxes.userBox);
}
