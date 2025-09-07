import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/locale_controller.dart';
import '../l10n/app_localizations.dart';
import '../routes/routes.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.account ?? 'Account',
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.settings),
            icon: Icon(Icons.settings, size: 24.w),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 未登录状态
        if (!controller.isLoggedIn) {
          return _buildNotLoggedInView(context);
        }

        // 已登录状态
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundImage: controller.avatar.isNotEmpty
                          ? NetworkImage(controller.avatar)
                          : null,
                      child: controller.avatar.isEmpty
                          ? Icon(Icons.person, size: 40.w)
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      controller.username,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.email.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        controller.email,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _buildMenuSection(context),
            ],
          ),
        );
      }),
    );
  }

  /// 未登录状态的视图
  Widget _buildNotLoggedInView(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 120.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              '您还未登录',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '请先登录以查看和管理您的账户信息',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  '立即登录',
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () {
                // 可以添加游客模式功能
                Get.snackbar('提示', '游客模式功能开发中');
              },
              child: Text(
                '以游客身份继续',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();
    
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit Profile',
        'onTap': () => _showEditProfileDialog(context),
      },
      {
        'icon': Icons.palette_outlined,
        'title': AppLocalizations.of(context)?.theme ?? 'Theme',
        'onTap': () => _showThemeDialog(context, themeController),
      },
      {
        'icon': Icons.language,
        'title': AppLocalizations.of(context)?.language ?? 'Language',
        'onTap': () => _showLanguageDialog(context, localeController),
      },
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'onTap': () => Get.snackbar('Info', 'Notifications page'),
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'title': 'Privacy',
        'onTap': () => Get.snackbar('Info', 'Privacy page'),
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'onTap': () => Get.snackbar('Info', 'Help & Support page'),
      },
      {
        'icon': Icons.info_outline,
        'title': 'About',
        'onTap': () => Get.toNamed(Routes.about),
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'onTap': () => _showLogoutDialog(context),
        'isDestructive': true,
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: item['isDestructive'] == true
                  ? Colors.red
                  : Theme.of(context).iconTheme.color,
              size: 24.w,
            ),
            title: Text(
              item['title'] as String,
              style: TextStyle(
                fontSize: 16.sp,
                color: item['isDestructive'] == true
                    ? Colors.red
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: Colors.grey,
            ),
            onTap: item['onTap'] as VoidCallback,
          ),
        );
      }).toList(),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeController themeController) {
    Get.dialog(
      AlertDialog(
        title: Text(AppLocalizations.of(context)?.theme ?? 'Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => RadioListTile<ThemeType>(
              title: Text(AppLocalizations.of(context)?.light ?? 'Light'),
              value: ThemeType.light,
              groupValue: themeController.themeMode,
              onChanged: (ThemeType? value) {
                if (value != null) {
                  themeController.changeTheme(value);
                }
              },
            )),
            Obx(() => RadioListTile<ThemeType>(
              title: Text(AppLocalizations.of(context)?.dark ?? 'Dark'),
              value: ThemeType.dark,
              groupValue: themeController.themeMode,
              onChanged: (ThemeType? value) {
                if (value != null) {
                  themeController.changeTheme(value);
                }
              },
            )),
            Obx(() => RadioListTile<ThemeType>(
              title: Text(AppLocalizations.of(context)?.system ?? 'System'),
              value: ThemeType.system,
              groupValue: themeController.themeMode,
              onChanged: (ThemeType? value) {
                if (value != null) {
                  themeController.changeTheme(value);
                }
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleController localeController) {
    Get.dialog(
      AlertDialog(
        title: Text(AppLocalizations.of(context)?.language ?? 'Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: localeController.supportedLocales.map((locale) {
            return Obx(() => RadioListTile<Locale>(
              title: Text(localeController.getLanguageName(locale)),
              value: locale,
              groupValue: localeController.locale,
              onChanged: (Locale? value) {
                if (value != null) {
                  localeController.changeLocale(value);
                }
              },
            ));
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final usernameController = TextEditingController(text: controller.username);
    final emailController = TextEditingController(text: controller.email);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateProfile({
                'username': usernameController.text,
                'email': emailController.text,
              });
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.logout();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}