import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Flutter三棵树结构可视化演示
class ThreeTreesVisualizationDemo extends StatefulWidget {
  const ThreeTreesVisualizationDemo({super.key});

  @override
  State<ThreeTreesVisualizationDemo> createState() => _ThreeTreesVisualizationDemoState();
}

class _ThreeTreesVisualizationDemoState extends State<ThreeTreesVisualizationDemo> {
  bool _showDetailed = false;
  String _currentWidget = 'Column';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter 三棵树可视化'),
        actions: [
          Switch(
            value: _showDetailed,
            onChanged: (value) {
              setState(() {
                _showDetailed = value;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 概述说明
            _buildOverviewCard(),
            
            SizedBox(height: 20.h),
            
            // 实际例子
            _buildExampleWidget(),
            
            SizedBox(height: 20.h),
            
            // 三棵树可视化
            _buildTreeVisualization(),
            
            SizedBox(height: 20.h),
            
            // 详细解释
            if (_showDetailed) _buildDetailedExplanation(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌳 Flutter 三棵树关系',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '三棵树是独立但相互引用的结构：',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            _buildRelationshipItem('🔵 Widget Tree', '配置层 - 描述"要什么"', Colors.blue),
            _buildRelationshipItem('🟡 Element Tree', '管理层 - 控制"何时变"', Colors.orange),
            _buildRelationshipItem('🟢 RenderObject Tree', '渲染层 - 决定"怎么画"', Colors.green),
            
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber.shade700),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '关键：Element是桥梁，连接Widget和RenderObject',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.amber.shade700,
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

  Widget _buildRelationshipItem(String title, String description, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ': $description'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleWidget() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📱 实际例子 - 当前Widget结构',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // 实际的Widget例子
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Text(
                    '这是一个Text Widget',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentWidget = _currentWidget == 'Column' ? 'Container' : 'Column';
                      });
                    },
                    child: Text('点击改变Widget'),
                  ),
                  SizedBox(height: 8.h),
                  if (_currentWidget == 'Column')
                    Icon(Icons.view_column, size: 32.w)
                  else
                    Icon(Icons.crop_square, size: 32.w),
                ],
              ),
            ),
            
            SizedBox(height: 12.h),
            Text(
              '💡 点击按钮观察：Widget改变时，三棵树如何协同工作',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeVisualization() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌳 三棵树结构可视化',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // 三棵树的并排显示
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget Tree
                Expanded(child: _buildWidgetTree()),
                
                // 连接线
                SizedBox(
                  width: 20.w,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      Icon(Icons.arrow_forward, size: 16.w),
                      SizedBox(height: 20.h),
                      Icon(Icons.arrow_forward, size: 16.w),
                      SizedBox(height: 20.h),
                      Icon(Icons.arrow_forward, size: 16.w),
                    ],
                  ),
                ),
                
                // Element Tree
                Expanded(child: _buildElementTree()),
                
                // 连接线
                SizedBox(
                  width: 20.w,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      Icon(Icons.arrow_forward, size: 16.w),
                      SizedBox(height: 20.h),
                      Icon(Icons.arrow_forward, size: 16.w),
                      SizedBox(height: 20.h),
                      Icon(Icons.arrow_forward, size: 16.w),
                    ],
                  ),
                ),
                
                // RenderObject Tree
                Expanded(child: _buildRenderObjectTree()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetTree() {
    return Column(
      children: [
        Text(
          'Widget Tree',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8.h),
        _buildTreeNode('Column', Colors.blue.shade100, Icons.view_column),
        _buildTreeConnection(),
        _buildTreeNode('Text', Colors.blue.shade100, Icons.text_fields),
        _buildTreeConnection(),
        _buildTreeNode('ElevatedButton', Colors.blue.shade100, Icons.smart_button),
        _buildTreeConnection(),
        _buildTreeNode('Icon', Colors.blue.shade100, Icons.image),
      ],
    );
  }

  Widget _buildElementTree() {
    return Column(
      children: [
        Text(
          'Element Tree',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 8.h),
        _buildTreeNode('ColumnElement', Colors.orange.shade100, Icons.manage_accounts),
        _buildTreeConnection(),
        _buildTreeNode('TextElement', Colors.orange.shade100, Icons.manage_accounts),
        _buildTreeConnection(),
        _buildTreeNode('ButtonElement', Colors.orange.shade100, Icons.manage_accounts),
        _buildTreeConnection(),
        _buildTreeNode('IconElement', Colors.orange.shade100, Icons.manage_accounts),
      ],
    );
  }

  Widget _buildRenderObjectTree() {
    return Column(
      children: [
        Text(
          'RenderObject Tree',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 8.h),
        _buildTreeNode('RenderFlex', Colors.green.shade100, Icons.grid_view),
        _buildTreeConnection(),
        _buildTreeNode('RenderParagraph', Colors.green.shade100, Icons.text_snippet),
        _buildTreeConnection(),
        _buildTreeNode('RenderBox', Colors.green.shade100, Icons.crop_square),
        _buildTreeConnection(),
        _buildTreeNode('RenderImage', Colors.green.shade100, Icons.image),
      ],
    );
  }

  Widget _buildTreeNode(String name, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16.w),
          SizedBox(height: 2.h),
          Text(
            name,
            style: TextStyle(fontSize: 10.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTreeConnection() {
    return Container(
      width: 2.w,
      height: 12.h,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildDetailedExplanation() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔍 详细解释',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            _buildDetailItem(
              '1. Widget Tree - 配置层',
              '• 不可变(Immutable)的配置对象\n'
              '• 描述UI应该长什么样\n'
              '• 每次setState()都会重新创建\n'
              '• 轻量级，只包含配置信息',
              Colors.blue,
            ),
            
            _buildDetailItem(
              '2. Element Tree - 管理层',
              '• 可变(Mutable)的管理对象\n'
              '• 连接Widget和RenderObject的桥梁\n'
              '• 负责Widget的生命周期管理\n'
              '• 尽可能复用，避免不必要的重建',
              Colors.orange,
            ),
            
            _buildDetailItem(
              '3. RenderObject Tree - 渲染层',
              '• 实际的渲染对象\n'
              '• 负责布局(Layout)、绘制(Paint)\n'
              '• 直接影响应用性能\n'
              '• 产生屏幕上的最终像素',
              Colors.green,
            ),
            
            SizedBox(height: 16.h),
            
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎯 关键理解',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '三棵树不是嵌套在一起的，而是通过引用关系连接：\n\n'
                    '• Element.widget → 指向对应的Widget\n'
                    '• Element.renderObject → 指向对应的RenderObject\n'
                    '• 这样设计实现了职责分离和性能优化',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String content, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 80.h,
            color: color,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  content,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}