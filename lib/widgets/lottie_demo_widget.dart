import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

/// Lottie心跳动画演示组件
class LottieDemoWidget extends StatefulWidget {
  const LottieDemoWidget({super.key});

  @override
  State<LottieDemoWidget> createState() => _LottieDemoWidgetState();
}

class _LottieDemoWidgetState extends State<LottieDemoWidget> 
    with TickerProviderStateMixin {
  
  late AnimationController _heartController;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化心跳动画控制器
    _heartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }
  
  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              '💖 心跳动画演示',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // 说明文字
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.pink.shade200),
              ),
              child: Text(
                '✨ 点击按钮播放心跳动画\n'
                '• 支持复杂的矢量动画\n'
                '• 文件体积小，性能优秀',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.pink.shade700,
                  height: 1.4,
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // 心跳动画展示
            _buildHeartAnimation(),
            
            SizedBox(height: 20.h),
            
            // 控制按钮
            _buildControlButton(),
          ],
        ),
      ),
    );
  }
  
  /// 构建心跳动画展示
  Widget _buildHeartAnimation() {
    return Center(
      child: Container(
        width: 150.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.pink.shade100,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.pink.shade300),
        ),
        child: Column(
          children: [
            Lottie.asset(
              'assets/lottie/heart.json',
              controller: _heartController,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      size: 50.w,
                      color: Colors.pink,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            Text(
              '心跳动画',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '点击下方按钮播放',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建控制按钮
  Widget _buildControlButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          _heartController.reset();
          _heartController.forward().then((_) {
            Get.snackbar(
              '💖 心跳完成',
              '心跳动画播放完毕',
              duration: Duration(seconds: 2),
              backgroundColor: Colors.pink.shade100,
              colorText: Colors.pink.shade700,
            );
          });
        },
        icon: Icon(Icons.favorite, size: 20.w),
        label: Text(
          '播放心跳动画',
          style: TextStyle(fontSize: 16.sp),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 12.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}