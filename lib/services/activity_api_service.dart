import 'package:get/get.dart';
import '../models/activity_model.dart';
import '../services/http_service.dart';

class ActivityApiService {
  late final HttpService _httpService;

  ActivityApiService() {
    _httpService = Get.find<HttpService>();
  }

  Future<List<ActivityModel>> getHomeActivityList() async {
    try {
      final response = await _httpService.getList<ActivityModel>(
        '/activity/list/home',
        fromJson: ActivityModel.fromJson,
      );
      
      print('Response success: ${response.success}');
      print('Response message: ${response.message}');
      print('Response data: ${response.data}');
      print('Response data type: ${response.data.runtimeType}');
      
      if (response.success && response.data != null) {
        return response.data!;
      }
      
      throw Exception('Failed to load activity data');
    } catch (e) {
      print('API Error details: $e');
      throw Exception('API Error: $e');
    }
  }

  Future<ActivityModel?> getActivityById(String activityId) async {
    try {
      final response = await _httpService.get<Map<String, dynamic>>('/activity/$activityId');
      
      if (response.success && response.data != null) {
        return ActivityModel.fromJson(response.data!);
      }
      
      return null;
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}