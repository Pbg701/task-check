import '../../data/models/checkin_model.dart';

class Checkin {
  final String id;
  final String taskId;
  final String notes;
  final String category;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String syncStatus;

  Checkin({
    required this.id,
    required this.taskId,
    required this.notes,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.syncStatus,
  });

  factory Checkin.fromModel(CheckinModel m) => Checkin(
    id: m.id,
    taskId: m.taskId,
    notes: m.notes,
    category: m.category,
    latitude: m.latitude,
    longitude: m.longitude,
    createdAt: m.createdAt,
    syncStatus: m.syncStatus,
  );

  CheckinModel toModel() => CheckinModel(
    id: id,
    taskId: taskId,
    notes: notes,
    category: category,
    latitude: latitude,
    longitude: longitude,
    createdAt: createdAt,
    syncStatus: syncStatus,
  );
}

