import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/locale_controller.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.settings ?? 'Settings',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.palette_outlined, size: 24.w),
                    title: Text(
                      AppLocalizations.of(context)?.theme ?? 'Theme',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Obx(() => DropdownButton<ThemeType>(
                      value: themeController.themeMode,
                      items: [
                        DropdownMenuItem(
                          value: ThemeType.light,
                          child: Text(
                            AppLocalizations.of(context)?.light ?? 'Light',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeType.dark,
                          child: Text(
                            AppLocalizations.of(context)?.dark ?? 'Dark',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        DropdownMenuItem(
                          value: ThemeType.system,
                          child: Text(
                            AppLocalizations.of(context)?.system ?? 'System',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                      onChanged: (ThemeType? value) {
                        if (value != null) {
                          themeController.changeTheme(value);
                        }
                      },
                    )),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.language, size: 24.w),
                    title: Text(
                      AppLocalizations.of(context)?.language ?? 'Language',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Obx(() => DropdownButton<Locale>(
                      value: localeController.locale,
                      items: localeController.supportedLocales.map((locale) {
                        return DropdownMenuItem(
                          value: locale,
                          child: Text(
                            localeController.getLanguageName(locale),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (Locale? value) {
                        if (value != null) {
                          localeController.changeLocale(value);
                        }
                      },
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline, size: 24.w),
                    title: Text(
                      'App Version',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Text(
                      '1.0.0',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.code, size: 24.w),
                    title: Text(
                      'Build Number',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Text(
                      '1',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}