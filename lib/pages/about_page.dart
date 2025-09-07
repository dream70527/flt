import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/about_controller.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              // App icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.flutter_dash,
                  size: 60.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              
              // App name
              Text(
                controller.appName,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              
              // Version info
              Text(
                'Version ${controller.version} (${controller.buildNumber})',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40.h),
              
              // Description
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'A Flutter application built with GetX for state management, featuring internationalization, theme switching, and network request capabilities.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              
              // Features
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...['GetX State Management', 'Internationalization', 'Theme Switching', 'Screen Adaptation', 'Network Requests', 'Responsive Design'].map(
                        (feature) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              
              // Technical info
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Technical Information',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow('Package Name', controller.packageName),
                      _buildInfoRow('Version', controller.version),
                      _buildInfoRow('Build Number', controller.buildNumber),
                      _buildInfoRow('Framework', 'Flutter'),
                      _buildInfoRow('State Management', 'GetX'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              
              // Copyright
              Text(
                '© 2024 ClaudeCodeFlt',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}