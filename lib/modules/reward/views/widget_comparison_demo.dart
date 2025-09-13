import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/available_rewards_widget.dart';
import '../widgets/available_rewards_stateful_widget.dart';

/// StatelessWidget vs StatefulWidget 对比演示
class WidgetComparisonDemo extends StatelessWidget {
  const WidgetComparisonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StatelessWidget vs StatefulWidget'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Get.forceAppUpdate();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明文档
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔍 Widget 类型对比',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '观察控制台输出，了解两种Widget的生命周期差异：',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '🏗️ build() 方法调用\n'
                      '🔧 initState() 初始化\n'
                      '🔄 didUpdateWidget() 更新\n'
                      '🗑️ dispose() 销毁',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // StatelessWidget 演示
            Text(
              '1️⃣ StatelessWidget + GetBuilder',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.h),
            
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '特点：',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '• 无内部状态，依赖外部数据\n'
                      '• 通过GetBuilder响应GetX状态变化\n'
                      '• 性能较好，重建开销小\n'
                      '• 适合展示型组件',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
            
            // 使用原版 StatelessWidget
            AvailableRewardsWidget(
              rewards: [], // 空数据演示
              onClaimReward: (id) => print('Claim: $id'),
              isLoading: false,
            ),
            
            SizedBox(height: 24.h),
            
            // StatefulWidget 演示
            Text(
              '2️⃣ StatefulWidget + GetBuilder',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8.h),
            
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '特点：',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '• 可以管理本地状态(setState)\n'
                      '• 同时支持GetX和本地状态管理\n'
                      '• 有完整的生命周期方法\n'
                      '• 适合交互复杂的组件',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
            
            // 使用 StatefulWidget 版本
            AvailableRewardsStatefulWidget(
              rewards: [], // 空数据演示
              onClaimReward: (id) => print('Claim: $id'),
              isLoading: false,
            ),
            
            SizedBox(height: 24.h),
            
            // 对比总结
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 总结对比',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    
                    _buildComparisonTable(),
                    
                    SizedBox(height: 12.h),
                    
                    Text(
                      '💡 建议：',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '• 纯展示组件 → StatelessWidget\n'
                      '• 需要本地状态管理 → StatefulWidget\n'
                      '• 复杂交互和动画 → StatefulWidget\n'
                      '• GetX已满足状态需求 → StatelessWidget',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        // 表头
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            _buildTableCell('特性', isHeader: true),
            _buildTableCell('StatelessWidget', isHeader: true),
            _buildTableCell('StatefulWidget', isHeader: true),
          ],
        ),
        // 数据行
        TableRow(children: [
          _buildTableCell('生命周期'),
          _buildTableCell('仅 build()'),
          _buildTableCell('完整生命周期'),
        ]),
        TableRow(children: [
          _buildTableCell('本地状态'),
          _buildTableCell('❌ 不支持'),
          _buildTableCell('✅ 支持 setState'),
        ]),
        TableRow(children: [
          _buildTableCell('性能'),
          _buildTableCell('🟢 轻量'),
          _buildTableCell('🟡 稍重'),
        ]),
        TableRow(children: [
          _buildTableCell('GetX集成'),
          _buildTableCell('✅ 完美'),
          _buildTableCell('✅ 完美'),
        ]),
        TableRow(children: [
          _buildTableCell('适用场景'),
          _buildTableCell('展示组件'),
          _buildTableCell('交互组件'),
        ]),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}