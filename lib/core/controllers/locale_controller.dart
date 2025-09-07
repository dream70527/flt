import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  static const String _localeKey = 'locale';
  
  final _locale = const Locale('en').obs;
  Locale get locale => _locale.value;

  final List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('zh'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  void _loadLocale() {
    final storage = GetStorage();
    final localeCode = storage.read(_localeKey) ?? 'en';
    _locale.value = Locale(localeCode);
    Get.updateLocale(_locale.value);
  }

  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      _locale.value = locale;
      Get.updateLocale(locale);
      GetStorage().write(_localeKey, locale.languageCode);
    }
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      default:
        return locale.languageCode;
    }
  }
}