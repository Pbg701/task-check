
import 'package:hive/hive.dart';

part 'checkin_model.g.dart';

@HiveType(typeId: 1)
class CheckinModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId;

  @HiveField(2)
  String notes;

  @HiveField(3)
  String category;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String syncStatus;

  CheckinModel({
    required this.id,
    required this.taskId,
    required this.notes,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.syncStatus,
  });

  factory CheckinModel.fromMap(Map<String, dynamic> map) {
    return CheckinModel(
      id: map['id'] ?? '',
      taskId: map['taskId'] ?? '',
      notes: map['notes'] ?? '',
      category: map['category'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
      syncStatus: map['syncStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'notes': notes,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }
}
