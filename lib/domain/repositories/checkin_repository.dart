import '../models/checkin.dart';

abstract class CheckinRepository {
  Future<List<Checkin>> fetchCheckinsForTask(String taskId);
  Future<void> createCheckin(Checkin checkin);
  Future<void> retryFailedSyncs();
  Future<void> syncCheckins();
  Future<List<Checkin>> getLocalCheckins(String taskId); // From Hive
}
