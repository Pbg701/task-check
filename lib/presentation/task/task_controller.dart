import 'package:get/get.dart';
import '../../domain/models/task.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../core/services/connectivity_service.dart';

class TaskController extends GetxController {
  final TaskRepositoryImpl _repo = TaskRepositoryImpl();
  final tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;
  final RxString selectedStatus = 'All'.obs;
  final List<Task> _allTasks = [];

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  int _priorityWeight(String p) {
    switch (p) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      default:
        return 1;
    }
  }

  void sortTasksByPriority() {
    tasks.sort((a, b) =>
        _priorityWeight(b.priority).compareTo(_priorityWeight(a.priority)));
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    errorMsg.value = '';

    try {
      final data = await _repo.getLocalTasks();

      _allTasks
        ..clear()
        ..addAll(data);

      tasks.value = List.from(_allTasks);

      if (Get.find<ConnectivityService>().isConnected.value) {
        await _repo.syncTasks();

        final synced = await _repo.getLocalTasks();
        _allTasks
          ..clear()
          ..addAll(synced);

        tasks.value = List.from(_allTasks);
      }
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void upsertTask(Task task) {
    final index = _allTasks.indexWhere((t) => t.id == task.id);

    if (index != -1) {
      _allTasks[index] = task;
      tasks[index] = task;
    } else {
      _allTasks.insert(0, task);
      tasks.insert(0, task);
    }

    tasks.refresh();
  }

  Future<void> deleteTask(Task task) async {
    isLoading.value = true;
    errorMsg.value = '';

    try {
      await _repo.deleteTask(task.id);

      // remove locally
      _allTasks.removeWhere((t) => t.id == task.id);
      tasks.removeWhere((t) => t.id == task.id);
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;

    if (status == 'All') {
      tasks.value = List.from(_allTasks);
    } else {
      tasks.value = _allTasks.where((t) => t.status == status).toList();
    }
  }

  // void sortTasksByPriority() {
  //   tasks.sort((a, b) => a.priority.compareTo(b.priority));
  // }

  void sortTasksByDueDate() {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }
}
