import '../../data/models/task_model.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime dueDate;
  final String location;
  final String assignedUserId;
  final DateTime updatedAt;
  final String syncStatus;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.location,
    required this.assignedUserId,
    required this.updatedAt,
    required this.syncStatus,
  });

  factory Task.fromModel(TaskModel m) => Task(
    id: m.id,
    title: m.title,
    description: m.description,
    status: m.status,
    priority: m.priority,
    dueDate: m.dueDate,
    location: m.location,
    assignedUserId: m.assignedUserId,
    updatedAt: m.updatedAt,
    syncStatus: m.syncStatus,
  );

  TaskModel toModel() => TaskModel(
    id: id,
    title: title,
    description: description,
    status: status,
    priority: priority,
    dueDate: dueDate,
    location: location,
    assignedUserId: assignedUserId,
    updatedAt: updatedAt,
    syncStatus: syncStatus,
  );
}

