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
      final response = await _httpService.get<List<ActivityModel>>(
        '/activity/list/home',
        converter: (data) => (data as List)
            .map((json) => ActivityModel.fromJson(json as Map<String, dynamic>))
            .toList(),
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
      final response = await _httpService.get<ActivityModel>(
        '/activity/$activityId',
        converter: (data) => ActivityModel.fromJson(data as Map<String, dynamic>),
      );
      
      if (response.success && response.data != null) {
        return response.data!;
      }
      
      return null;
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}