import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/custom_icons.dart';

class IconDemoPage extends StatelessWidget {
  const IconDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义图标演示'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. 图片资源图标',
              '将 PNG/JPG 图片放入 assets/images/icons/ 目录',
              _buildAssetIcons(),
            ),
            
            SizedBox(height: 24.h),
            
            _buildSection(
              '2. 网络图标',
              '从网络加载图标，支持加载状态和错误处理',
              _buildNetworkIcons(),
            ),
            
            SizedBox(height: 24.h),
            
            _buildSection(
              '3. Material 图标变体',
              '使用不同颜色和大小的 Material 图标',
              _buildMaterialIcons(),
            ),
            
            SizedBox(height: 24.h),
            
            _buildSection(
              '4. 图标按钮示例',
              '可点击的自定义图标按钮',
              _buildIconButtons(),
            ),
            
            SizedBox(height: 24.h),
            
            _buildSection(
              '5. 使用建议',
              '',
              _buildUsageTips(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: content,
        ),
      ],
    );
  }

  Widget _buildAssetIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('示例（需要先添加图片到 assets/images/icons/ 目录）:'),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildIconDemo(
              'game_icon.png',
              '游戏图标',
              () => CustomIcons.assetIcon(
                'assets/images/icons/game_icon.png',
                size: 32,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 16.w),
            _buildIconDemo(
              'custom_home.png', 
              '首页图标',
              () => CustomIcons.assetIcon(
                'assets/images/icons/custom_home.png',
                size: 32,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: const Text(
            '代码示例:\n'
            'CustomIcons.assetIcon(\n'
            '  \'assets/images/icons/game_icon.png\',\n'
            '  size: 32,\n'
            '  color: Colors.blue,\n'
            ')',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('从网络加载图标:'),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildIconDemo(
              '网络图标',
              '带加载状态',
              () => CustomIcons.networkIcon(
                'https://cdn-icons-png.flaticon.com/512/2/2235.png',
                size: 32,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: const Text(
            '代码示例:\n'
            'CustomIcons.networkIcon(\n'
            '  \'https://example.com/icon.png\',\n'
            '  size: 32,\n'
            ')',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialIcons() {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        _buildIconDemo('home', '默认', () => const Icon(Icons.home)),
        _buildIconDemo('home', '大号蓝色', () => const Icon(Icons.home, size: 32, color: Colors.blue)),
        _buildIconDemo('favorite', '红色', () => const Icon(Icons.favorite, color: Colors.red)),
        _buildIconDemo('settings', '绿色', () => const Icon(Icons.settings, color: Colors.green)),
      ],
    );
  }

  Widget _buildIconButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('可点击的图标按钮:'),
        SizedBox(height: 8.h),
        Row(
          children: [
            CustomIcons.assetIconButton(
              'assets/images/icons/game_icon.png',
              onPressed: () => Get.snackbar('点击', '游戏图标被点击'),
              tooltip: '打开游戏',
              size: 32,
              color: Colors.blue,
            ),
            SizedBox(width: 16.w),
            IconButton(
              onPressed: () => Get.snackbar('点击', '设置图标被点击'),
              icon: const Icon(Icons.settings, size: 32),
              tooltip: '打开设置',
              color: Colors.grey[700],
            ),
            SizedBox(width: 16.w),
            IconButton(
              onPressed: () => Get.snackbar('点击', '收藏图标被点击'),
              icon: const Icon(Icons.favorite, size: 32),
              tooltip: '收藏',
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsageTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTip('1. 图片格式', 'PNG 格式最佳，支持透明背景'),
        _buildTip('2. 图片尺寸', '建议使用 24x24, 32x32, 48x48 等标准尺寸'),
        _buildTip('3. 颜色支持', 'ImageIcon 支持 color 参数改变颜色，但仅对单色图标有效'),
        _buildTip('4. 性能优化', '频繁使用的图标建议放在 assets 中，避免网络加载'),
        _buildTip('5. 高分辨率', '可以提供 @2x、@3x 版本适配不同屏幕密度'),
      ],
    );
  }

  Widget _buildTip(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 16.w, color: Colors.amber[700]),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconDemo(String name, String description, Widget Function() iconBuilder) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: iconBuilder(),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          name,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          description,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}