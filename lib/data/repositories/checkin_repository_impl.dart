import '../../domain/repositories/checkin_repository.dart';
import '../../domain/models/checkin.dart';
import '../local/hive_service.dart';
import '../remote/firebase_service.dart';
import 'package:uuid/uuid.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final _firebase = FirebaseService();

  @override
  Future<void> createCheckin(Checkin checkin) async {
    final box = await HiveService.openCheckinBox();
    final id = checkin.id.isEmpty ? const Uuid().v4() : checkin.id;
    final localModel = checkin.toModel()..id = id;
    await box.put(id, localModel);
    // Try to sync immediately (if online)
    try {
      await _firebase.uploadCheckin(localModel.toMap(), id);
      localModel.syncStatus = 'synced';
    } catch (_) {
      localModel.syncStatus = 'pending';
    }
    await box.put(id, localModel);
  }

  @override
  Future<List<Checkin>> fetchCheckinsForTask(String taskId) async {
    final box = await HiveService.openCheckinBox();
    return box.values
        .where((c) => c.taskId == taskId)
        .map((c) => Checkin.fromModel(c))
        .toList();
  }

  @override
  Future<void> retryFailedSyncs() async {
    final box = await HiveService.openCheckinBox();
    for (var c in box.values.where((c) => c.syncStatus == 'pending' || c.syncStatus == 'failed')) {
      try {
        await _firebase.uploadCheckin(c.toMap(), c.id);
        c.syncStatus = 'synced';
        await box.put(c.id, c);
      } catch (_) {}
    }
  }

  @override
  Future<List<Checkin>> getLocalCheckins(String taskId) async {
    final box = await HiveService.openCheckinBox();
    return box.values
        .where((c) => c.taskId == taskId)
        .map((c) => Checkin.fromModel(c))
        .toList();
  }

  @override
  Future<void> syncCheckins() async {
    await retryFailedSyncs();
  }
}