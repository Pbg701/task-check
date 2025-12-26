import '../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks({int? limit, int? offset});
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<Task?> getTaskById(String id);
  Future<List<Task>> getLocalTasks(); // From Hive
  Future<void> cacheTasks(List<Task> tasks);
  Future<void> syncTasks();
}
