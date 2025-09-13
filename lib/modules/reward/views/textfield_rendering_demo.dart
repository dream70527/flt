import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// TextField 渲染机制演示页面
class TextFieldRenderingDemo extends StatefulWidget {
  const TextFieldRenderingDemo({super.key});

  @override
  State<TextFieldRenderingDemo> createState() => _TextFieldRenderingDemoState();
}

class _TextFieldRenderingDemoState extends State<TextFieldRenderingDemo> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextField 渲染机制对比'),
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
                      '🔍 TextField 渲染机制揭秘',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Flutter TextField 和原生输入框的区别：',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '• Flutter TextField = Skia自绘 + 跨平台一致\n'
                      '• 原生输入框 = 系统控件 + 平台特定外观\n'
                      '• 两者在底层完全不同的渲染路径',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Flutter Material Design TextField
            _buildSection(
              '1️⃣ Flutter Material TextField',
              'Skia引擎自绘，Material Design风格',
              Colors.blue,
              [
                TextField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    labelText: 'Material Design输入框',
                    hintText: '这是Flutter自绘的Material风格',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: Icon(Icons.clear),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    labelText: '自定义样式输入框',
                    hintText: '可以任意定制外观',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon: Icon(Icons.search, color: Colors.purple),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
            // Flutter Cupertino TextField
            _buildSection(
              '2️⃣ Flutter Cupertino TextField',
              'Skia引擎自绘，iOS风格模拟',
              Colors.orange,
              [
                CupertinoTextField(
                  controller: _controller2,
                  placeholder: 'iOS风格输入框（Flutter模拟）',
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: CupertinoColors.tertiarySystemFill,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefix: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Icon(CupertinoIcons.person, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 12.h),
                CupertinoTextField(
                  controller: _controller2,
                  placeholder: '带边框的iOS风格',
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
            // 原生对比说明
            _buildSection(
              '3️⃣ 原生 iOS UITextField（对比）',
              '系统原生控件，无法在Flutter中直接使用',
              Colors.red,
              [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '❌ 原生UITextField无法直接在Flutter中使用',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '原生iOS输入框特点：\n'
                        '• 由iOS系统UIKit框架渲染\n'
                        '• 自动适配iOS系统主题\n'
                        '• 完美的系统集成（键盘、辅助功能等）\n'
                        '• 但无法在Flutter中直接使用',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
            // 技术对比
            _buildTechnicalComparison(),
            
            SizedBox(height: 24.h),
            
            // 渲染流程图
            _buildRenderingFlow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, Color color, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 12.h),
        ...children,
      ],
    );
  }

  Widget _buildTechnicalComparison() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔧 技术对比详解',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                _buildTableRow(['特性', 'Flutter TextField', '原生 iOS'], isHeader: true),
                _buildTableRow(['渲染引擎', 'Skia图形库', 'Core Animation']),
                _buildTableRow(['绘制方式', '像素级自绘', '系统控件']),
                _buildTableRow(['跨平台', '完全一致', '平台特定']),
                _buildTableRow(['定制性', '无限制', '受系统限制']),
                _buildTableRow(['性能', 'GPU直接渲染', '系统控件开销']),
                _buildTableRow(['键盘处理', '需要特殊处理', '自动处理']),
                _buildTableRow(['辅助功能', '手动适配', '自动支持']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader ? BoxDecoration(color: Colors.grey.shade100) : null,
      children: cells.map((cell) => Padding(
        padding: EdgeInsets.all(8.w),
        child: Text(
          cell,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }

  Widget _buildRenderingFlow() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎨 渲染流程对比',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 12.h),
            
            // Flutter渲染流程
            _buildFlowItem(
              'Flutter TextField 渲染流程：',
              [
                '1. TextField Widget',
                '2. EditableText RenderObject',
                '3. Skia Canvas绘制',
                '4. GPU渲染',
                '5. 屏幕显示',
              ],
              Colors.blue,
            ),
            
            SizedBox(height: 16.h),
            
            // 原生渲染流程
            _buildFlowItem(
              '原生 iOS UITextField 渲染流程：',
              [
                '1. UITextField创建',
                '2. UIKit布局计算',
                '3. Core Animation处理',
                '4. Metal/OpenGL渲染',
                '5. 屏幕显示',
              ],
              Colors.orange,
            ),
            
            SizedBox(height: 16.h),
            
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.orange),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '关键区别：Flutter完全绕过了原生UI控件，直接使用图形库绘制，这是性能和一致性的关键！',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
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

  Widget _buildFlowItem(String title, List<String> steps, Color color) {
    return Column(
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
        SizedBox(height: 8.h),
        Row(
          children: steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      step,
                      style: TextStyle(fontSize: 10.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (index < steps.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 12.w,
                        color: color,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
}