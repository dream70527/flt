import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/counter_controller.dart';

/// 使用独立 Controller 的示例组件
class IndependentCounterWidget extends StatelessWidget {
  const IndependentCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 懒加载 CounterController
    Get.lazyPut(() => CounterController());
    
    return GetBuilder<CounterController>(
      builder: (counter) {
        print('🎯 IndependentCounterWidget build - 独立更新');
        return Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            children: [
              Text(
                '独立计数器: ${counter.count}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: counter.decrement,
                    child: Text('-'),
                  ),
                  ElevatedButton(
                    onPressed: counter.increment,
                    child: Text('+'),
                  ),
                  ElevatedButton(
                    onPressed: counter.reset,
                    child: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}