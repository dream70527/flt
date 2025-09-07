import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/theme_controller.dart';
import 'controllers/locale_controller.dart';
import 'services/http_service.dart';
import 'routes/app_pages.dart';
import 'routes/routes.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  
  await _initServices();
  
  runApp(const MyApp());
}

Future<void> _initServices() async {
  Get.put<HttpService>(HttpService(), permanent: true);
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<LocaleController>(LocaleController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'ClaudeCodeFlt',
          debugShowCheckedModeBanner: false,
          
          theme: Get.find<ThemeController>().lightTheme,
          darkTheme: Get.find<ThemeController>().darkTheme,
          themeMode: ThemeMode.system,
          
          locale: Get.find<LocaleController>().locale,
          fallbackLocale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Get.find<LocaleController>().supportedLocales,
          
          initialRoute: Routes.main,
          getPages: AppPages.routes,
          
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}