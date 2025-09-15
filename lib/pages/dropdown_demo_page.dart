import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/animated_dropdown.dart';

class DropdownDemoPage extends StatefulWidget {
  const DropdownDemoPage({super.key});

  @override
  State<DropdownDemoPage> createState() => _DropdownDemoPageState();
}

class _DropdownDemoPageState extends State<DropdownDemoPage> {
  DropdownItem? selectedCity;
  DropdownItem? selectedCategory;
  DropdownItem? selectedLanguage;

  // 城市选项
  final List<DropdownItem> cities = [
    DropdownItem(value: 'beijing', label: '北京', icon: Icons.location_city),
    DropdownItem(value: 'shanghai', label: '上海', icon: Icons.location_city),
    DropdownItem(value: 'guangzhou', label: '广州', icon: Icons.location_city),
    DropdownItem(value: 'shenzhen', label: '深圳', icon: Icons.location_city),
    DropdownItem(value: 'hangzhou', label: '杭州', icon: Icons.location_city),
    DropdownItem(value: 'nanjing', label: '南京', icon: Icons.location_city),
    DropdownItem(value: 'wuhan', label: '武汉', icon: Icons.location_city),
    DropdownItem(value: 'chengdu', label: '成都', icon: Icons.location_city),
  ];

  // 分类选项
  final List<DropdownItem> categories = [
    DropdownItem(value: 'tech', label: '科技数码', icon: Icons.computer),
    DropdownItem(value: 'fashion', label: '时尚服饰', icon: Icons.checkroom),
    DropdownItem(value: 'food', label: '美食餐饮', icon: Icons.restaurant),
    DropdownItem(value: 'travel', label: '旅游出行', icon: Icons.flight),
    DropdownItem(value: 'education', label: '教育培训', icon: Icons.school),
  ];

  // 语言选项
  final List<DropdownItem> languages = [
    DropdownItem(value: 'zh', label: '中文', icon: Icons.language),
    DropdownItem(value: 'en', label: 'English', icon: Icons.language),
    DropdownItem(value: 'ja', label: '日本語', icon: Icons.language),
    DropdownItem(value: 'ko', label: '한국어', icon: Icons.language),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动画下拉组件演示'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 介绍卡片
            _buildIntroCard(),
            
            SizedBox(height: 24.h),
            
            // 基础演示
            _buildBasicDemo(),
            
            SizedBox(height: 24.h),
            
            // 样式演示
            _buildStyleDemo(),
            
            SizedBox(height: 24.h),
            
            // 效果说明
            _buildEffectDescription(),
            
            SizedBox(height: 24.h),
            
            // 选中结果显示
            _buildResultDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎨 动画下拉组件特性',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '• 流畅的下拉展开/收起动画\n'
              '• 箭头旋转动画效果\n'
              '• 支持图标和自定义样式\n'
              '• 选中状态高亮显示\n'
              '• 支持长列表滚动\n'
              '• 完全自定义外观',
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicDemo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📍 基础演示',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // 城市选择
            Text(
              '选择城市',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            AnimatedDropdown(
              items: cities,
              value: selectedCity,
              hint: '请选择城市',
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 分类选择
            Text(
              '选择分类',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            AnimatedDropdown(
              items: categories,
              value: selectedCategory,
              hint: '请选择分类',
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleDemo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎭 样式定制演示',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // 自定义样式的下拉框
            Text(
              '语言设置（自定义样式）',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            AnimatedDropdown(
              items: languages,
              value: selectedLanguage,
              hint: '选择语言',
              height: 56,
              backgroundColor: Colors.purple.shade50,
              borderColor: Colors.purple.shade300,
              borderRadius: BorderRadius.circular(12.r),
              textStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.purple.shade400,
              ),
              animationDuration: Duration(milliseconds: 400),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
            ),
            
            SizedBox(height: 20.h),
            
            // 快速动画演示
            Text(
              '快速动画（150ms）',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            AnimatedDropdown(
              items: [
                DropdownItem(value: 'fast', label: '快速动画', icon: Icons.speed),
                DropdownItem(value: 'normal', label: '正常动画', icon: Icons.play_arrow),
                DropdownItem(value: 'slow', label: '慢速动画', icon: Icons.slow_motion_video),
              ],
              hint: '选择动画速度',
              backgroundColor: Colors.green.shade50,
              borderColor: Colors.green.shade300,
              animationDuration: Duration(milliseconds: 150),
              onChanged: (value) {
                // 可以根据选择调整其他组件的动画速度
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectDescription() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚡ 动画效果说明',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade700,
              ),
            ),
            SizedBox(height: 12.h),
            
            _buildEffectItem(
              icon: Icons.expand_more,
              title: '箭头旋转动画',
              description: '点击时箭头顺滑旋转180度，收起时反向旋转',
              color: Colors.blue,
            ),
            
            SizedBox(height: 12.h),
            
            _buildEffectItem(
              icon: Icons.animation,
              title: '下拉展开动画',
              description: '使用缩放+透明度动画，从顶部中心展开',
              color: Colors.green,
            ),
            
            SizedBox(height: 12.h),
            
            _buildEffectItem(
              icon: Icons.touch_app,
              title: '交互反馈',
              description: '选中项高亮显示，悬停效果，点击涟漪动画',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 18.w),
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
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultDisplay() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 选择结果',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            _buildResultItem('城市', selectedCity?.label ?? '未选择'),
            _buildResultItem('分类', selectedCategory?.label ?? '未选择'),
            _buildResultItem('语言', selectedLanguage?.label ?? '未选择'),
            
            SizedBox(height: 16.h),
            
            if (selectedCity != null || selectedCategory != null || selectedLanguage != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '✨ 很好！你已经体验了动画下拉组件的效果',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: value == '未选择' ? Colors.grey.shade400 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}