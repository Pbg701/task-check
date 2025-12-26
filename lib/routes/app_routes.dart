

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_task_checkin_app/presentation/auth/auth_controller.dart';
import 'package:offline_task_checkin_app/presentation/auth/role_section_view.dart';
import 'package:offline_task_checkin_app/presentation/task/task_detail_view.dart';
import 'package:offline_task_checkin_app/presentation/task/task_list_view.dart'
    show TaskListView;
import '../presentation/splash/splash_view.dart';
import '../presentation/auth/login_view.dart';
import '../presentation/checkin/checkin_form_view.dart';
import '../presentation/admin/admin_task_form_view.dart';
class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const taskList = '/tasks';
  static const taskDetail = '/taskDetail';
  static const checkinForm = '/checkin';
  static const adminTaskForm = '/admin/taskForm';
  static const roleSelection = '/role-selection';
  static final routes = [
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: taskList, page: () => TaskListView()),
    GetPage(name: taskDetail, page: () => const TaskDetailView()),
    GetPage(name: checkinForm, page: () => CheckinFormView()),
    GetPage(
      name: AppRoutes.roleSelection,
      page: () => const RoleSelectionView(),
    ),
    // ADMIN ONLY
    GetPage(
      name: adminTaskForm,
      page: () => const AdminTaskFormView(),
      middlewares: [AdminMiddleware()],
    ),
  ];
}

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (auth.currentUser.value?.role != 'admin') {
      return const RouteSettings(name: AppRoutes.taskList);
    }
    return null;
  }
}
