import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/discover_controller.dart';

class DiscoverPage extends GetView<DiscoverController> {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: controller.refresh,
            icon: Icon(Icons.refresh, size: 24.w),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // 热门推荐卡片
                _buildTrendingCard(context),
                
                SizedBox(height: 24.h),
                
                // 分类导航
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildCategoryGrid(context),
                
                SizedBox(height: 24.h),
                
                // 推荐内容列表
                Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                if (controller.recommendations.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.recommendations.length,
                    itemBuilder: (context, index) {
                      final item = controller.recommendations[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: ListTile(
                          leading: Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.explore,
                              color: Theme.of(context).primaryColor,
                              size: 30.w,
                            ),
                          ),
                          title: Text(
                            item['title'] ?? 'Title',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            item['description'] ?? 'Description',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
                          onTap: () => controller.openItem(item),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(40.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.explore_outlined,
                          size: 48.w,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'No content available',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTrendingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.purple.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 32.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending Now',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Discover what\'s popular today',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'icon': Icons.music_note, 'label': 'Music', 'color': Colors.red},
      {'icon': Icons.movie, 'label': 'Movies', 'color': Colors.blue},
      {'icon': Icons.sports_esports, 'label': 'Games', 'color': Colors.green},
      {'icon': Icons.book, 'label': 'Books', 'color': Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: InkWell(
            onTap: () => controller.openCategory(category['label'] as String),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 32.w,
                    color: category['color'] as Color,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category['label'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}