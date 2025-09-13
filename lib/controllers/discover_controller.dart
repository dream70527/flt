import 'package:get/get.dart';

class DiscoverController extends GetxController {
  final _isLoading = false.obs;
  final _recommendations = <Map<String, dynamic>>[].obs;

  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get recommendations => _recommendations;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      // 模拟数据加载
      await Future.delayed(const Duration(milliseconds: 500));
      
      _recommendations.value = [
        {
          'id': '1',
          'title': 'Trending Topic 1',
          'description': 'This is a trending topic worth exploring',
          'category': 'trending',
        },
        {
          'id': '2',
          'title': 'Popular Content',
          'description': 'Popular content that everyone is talking about',
          'category': 'popular',
        },
        {
          'id': '3',
          'title': 'New Release',
          'description': 'Just released and already gaining attention',
          'category': 'new',
        },
        {
          'id': '4',
          'title': 'Featured Item',
          'description': 'Featured content handpicked for you',
          'category': 'featured',
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load content');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadData();
  }

  void openItem(Map<String, dynamic> item) {
    Get.snackbar('Info', 'Opening: ${item['title']}');
  }

  void openCategory(String category) {
    Get.snackbar('Info', 'Opening category: $category');
  }
}