
import 'package:get/get.dart';
import '../../domain/models/checkin.dart';
import '../../data/repositories/checkin_repository_impl.dart';
import '../../core/services/location_service.dart';

class CheckinController extends GetxController {
  final notes = ''.obs;
  final category = 'Safety'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  Future<void> submitCheckin(String taskId) async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      final loc = await LocationService.getCurrentPosition();
      if (notes.value.length < 10) {
        errorMsg.value = 'Notes must be at least 10 characters.';
        return;
      }
      final checkin = Checkin(
        id: '', // Will be set by Hive/Sync
        taskId: taskId,
        notes: notes.value,
        category: category.value,
        latitude: loc.latitude,
        longitude: loc.longitude,
        createdAt: DateTime.now(),
        syncStatus: 'pending',
      );
      await CheckinRepositoryImpl().createCheckin(checkin);
      Get.back(result: true);
    } catch (e) {
      errorMsg.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}
