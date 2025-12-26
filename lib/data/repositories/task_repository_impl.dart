import '../../domain/repositories/task_repository.dart';
import '../../domain/models/task.dart';
import '../models/task_model.dart';
import '../local/hive_service.dart';
import '../remote/firebase_service.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  final _firebase = FirebaseService();

  @override
  Future<List<Task>> fetchTasks({int? limit, int? offset}) async {
    // Always fetch remote, update local cache
    final remotes = await _firebase.fetchRemoteTasks();
    final models = remotes.map((map) => TaskModel.fromMap(map)).toList();
    await cacheTasks(models.map((m) => Task.fromModel(m)).toList());
    return models.map((m) => Task.fromModel(m)).toList();
  }

  @override
  Future<void> cacheTasks(List<Task> tasks) async {
    final box = await HiveService.openTaskBox();
    await box.clear();
    for (var t in tasks) {
      await box.put(t.id, t.toModel());
    }
  }

  @override
  Future<void> createTask(Task task) async {
    final box = await HiveService.openTaskBox();
    final newId = task.id.isEmpty ? const Uuid().v4() : task.id;
    final model = task.toModel()..id = newId;
    await box.put(newId, model);
    // Upload to remote
    await _firebase.uploadTask(model.toMap());
  }

  @override
  Future<void> updateTask(Task task) async {
    final box = await HiveService.openTaskBox();
    await box.put(task.id, task.toModel());
    await _firebase.uploadTask(task.toModel().toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final box = await HiveService.openTaskBox();
    await box.delete(taskId);
    // Optionally add remote removal logic if needed
  }


  @override
  Future<Task?> getTaskById(String id) async {
    final box = await HiveService.openTaskBox();
    final model = box.get(id);
    return model != null ? Task.fromModel(model) : null;
  }

  @override
  Future<List<Task>> getLocalTasks() async {
    final box = await HiveService.openTaskBox();
    return box.values.map((m) => Task.fromModel(m)).toList();
  }

  @override
  Future<void> syncTasks() async {
    // Re-upload all pending/unsynced as needed (not shown, simple for demo)
    // After uploading, mark as synced
  }
}
