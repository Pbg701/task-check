import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String status; // Open, In Progress, Done
  @HiveField(4)
  String priority; // Low, Medium, High
  @HiveField(5)
  DateTime dueDate;
  @HiveField(6)
  String location;
  @HiveField(7)
  String assignedUserId;
  @HiveField(8)
  DateTime updatedAt;
  @HiveField(9)
  String syncStatus; // pending, synced, failed

  TaskModel({
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

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    status: map['status'],
    priority: map['priority'],
    dueDate: (map['dueDate'] as Timestamp?)?.toDate() ?? DateTime.parse(map['dueDate']),
    location: map['location'],
    assignedUserId: map['assignedUserId'],
    updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.parse(map['updatedAt']),
    syncStatus: map['syncStatus'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'dueDate': dueDate.toIso8601String(),
    'location': location,
    'assignedUserId': assignedUserId,
    'updatedAt': updatedAt.toIso8601String(),
    'syncStatus': syncStatus,
  };
}

