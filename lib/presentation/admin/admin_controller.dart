import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/models/task.dart';
import '../../data/repositories/task_repository_impl.dart';

class AdminController extends GetxController {
  final TaskRepositoryImpl _repo = TaskRepositoryImpl();

  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  Future<void> saveTask(
    Task task, {
    bool isEdit = false,
    VoidCallback? onSuccess,
  }) async {
    isLoading.value = true;
    errorMsg.value = '';

    try {
      if (isEdit) {
        await _repo.updateTask(task);
      } else {
        await _repo.createTask(task);
      }

      onSuccess?.call(); // UI update

      Get.back(); //  close form

      Get.snackbar(
        'Task Saved',
        'Task has been successfully saved.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
