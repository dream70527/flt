import 'package:get/get.dart';
import '../models/activity_model.dart';
import '../services/activity_api_service.dart';

class HomeController extends GetxController {
  final _isLoading = false.obs;
  final _activities = <ActivityModel>[].obs;

  bool get isLoading => _isLoading.value;
  List<ActivityModel> get activities => _activities;

  late final ActivityApiService _activityApiService;

  @override
  void onInit() {
    super.onInit();
    _activityApiService = ActivityApiService();
    loadData();
  }

  Future<void> loadData() async {
    try {
      _isLoading.value = true;

      final activities = await _activityApiService.getHomeActivityList();
      _activities.value = activities;
    } catch (e) {
      Get.snackbar('Error', ' $e');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadData();
  }
}