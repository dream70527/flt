import 'package:get/get.dart';

class AboutController extends GetxController {
  final _isLoading = false.obs;
  
  bool get isLoading => _isLoading.value;
  
  String get appName => 'ClaudeCodeFlt';
  String get version => '1.0.0';
  String get buildNumber => '1';
  String get packageName => 'com.example.claudecodeflt';
}