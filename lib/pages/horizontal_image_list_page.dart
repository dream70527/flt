import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalImageListPage extends StatefulWidget {
  const HorizontalImageListPage({super.key});

  @override
  State<HorizontalImageListPage> createState() => _HorizontalImageListPageState();
}

class _HorizontalImageListPageState extends State<HorizontalImageListPage> {
  int selectedIndex = 0;
  
  // 用于缓存预加载的图片
  final Map<String, ImageProvider> _cachedImages = {};

  // 示例数据：每个索引对应两张网络图片
  final List<ImagePair> imageList = [
    ImagePair(
      normalImage: 'https://picsum.photos/150/150?random=1',
      selectedImage: 'https://picsum.photos/150/150?random=11',
      title: '图片1',
    ),
    ImagePair(
      normalImage: 'https://picsum.photos/150/150?random=2',
      selectedImage: 'https://picsum.photos/150/150?random=12',
      title: '图片2',
    ),
    ImagePair(
      normalImage: 'https://picsum.photos/150/150?random=3',
      selectedImage: 'https://picsum.photos/150/150?random=13',
      title: '图片3',
    ),
    ImagePair(
      normalImage: 'https://picsum.photos/150/150?random=4',
      selectedImage: 'https://picsum.photos/150/150?random=14',
      title: '图片4',
    ),
    ImagePair(
      normalImage: 'https://picsum.photos/150/150?random=5',
      selectedImage: 'https://picsum.photos/150/150?random=15',
      title: '图片5',
    ),
    ImagePair(
      normalImage: 'https://picsum.photos/150/150?random=6',
      selectedImage: 'https://picsum.photos/150/150?random=16',
      title: '图片6',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 初始化图片提供者，但不在这里预加载
    for (final imagePair in imageList) {
      // _cachedImages[imagePair.normalImage] = NetworkImage(imagePair.normalImage);
      // _cachedImages[imagePair.selectedImage] = NetworkImage(imagePair.selectedImage);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  // 预加载所有图片
  void _preloadImages() {
    for (final imagePair in imageList) {
      // 预加载普通状态图片
      // precacheImage(_cachedImages[imagePair.normalImage]!, context);
      //
      // // 预加载选中状态图片
      // precacheImage(_cachedImages[imagePair.selectedImage]!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('横向图片列表'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 横向ListView
          Container(
            height: 200.h,
            margin: EdgeInsets.all(16.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                final imagePair = imageList[index];
                final isSelected = selectedIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    width: 150.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.transparent,
                        width: 2.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        // 图片
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Stack(
                              children: [
                                // 普通状态图片（底层）
                                Positioned.fill(
                                  child: Image(
                                    image:
                                           NetworkImage(imagePair.normalImage),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.grey[600],
                                          size: 40.w,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // 选中状态图片（顶层）
                                Positioned.fill(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isSelected ? 1.0 : 0.0,
                                    child: Image(
                                      image:
                                             NetworkImage(imagePair.selectedImage),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.grey[600],
                                            size: 40.w,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 标题
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            imagePair.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 当前选中的信息展示
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前选中：${imageList[selectedIndex].title}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '普通状态图片：',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    imageList[selectedIndex].normalImage,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '选中状态图片：',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    imageList[selectedIndex].selectedImage,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePair {
  final String normalImage;
  final String selectedImage;
  final String title;

  ImagePair({
    required this.normalImage,
    required this.selectedImage,
    required this.title,
  });
}