import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 虚线边框绘制器
/// 
/// 这是一个自定义的绘制器，用于绘制虚线边框
/// 继承自 CustomPainter，可以在 CustomPaint 组件中使用
/// 
/// 使用示例:
/// ```dart
/// CustomPaint(
///   painter: DashedBorderPainter(
///     color: Colors.blue,        // 虚线颜色
///     strokeWidth: 2.0,          // 线条粗细
///     dashLength: 8.0,           // 虚线段长度
///     gapLength: 4.0,            // 虚线间隔长度
///     borderRadius: 12.0,        // 圆角半径（0为直角）
///   ),
///   child: Container(...),
/// )
/// ```
class DashedBorderPainter extends CustomPainter {
  /// 虚线的颜色
  final Color color;
  
  /// 线条的粗细（宽度）
  final double strokeWidth;
  
  /// 每个虚线段的长度
  final double dashLength;
  
  /// 虚线段之间的间隔长度
  final double gapLength;
  
  /// 边框的圆角半径，0表示直角边框
  final double borderRadius;

  /// 构造函数，设置虚线边框的各种属性
  const DashedBorderPainter({
    this.color = Colors.black,      // 默认黑色
    this.strokeWidth = 1.0,         // 默认线宽1像素
    this.dashLength = 5.0,          // 默认虚线段长度5像素
    this.gapLength = 3.0,           // 默认间隔3像素
    this.borderRadius = 0.0,        // 默认直角（无圆角）
  });

  /// 绘制方法，这是 CustomPainter 的核心方法
  /// canvas: 画布，用于绘制图形
  /// size: 绘制区域的大小
  @override
  void paint(Canvas canvas, Size size) {
    // 创建画笔，设置颜色、线宽和绘制样式
    final paint = Paint()
      ..color = color                    // 设置颜色
      ..strokeWidth = strokeWidth        // 设置线宽
      ..style = PaintingStyle.stroke;    // 设置为描边模式（不填充）

    // 根据是否有圆角来选择不同的绘制方法
    if (borderRadius > 0) {
      // 有圆角：绘制圆角虚线边框
      _drawDashedRoundedRect(canvas, size, paint);
    } else {
      // 无圆角：绘制直角虚线边框
      _drawDashedRect(canvas, size, paint);
    }
  }

  /// 绘制直角虚线边框
  /// 分别绘制上、右、下、左四条边
  void _drawDashedRect(Canvas canvas, Size size, Paint paint) {
    // 绘制上边：从左上角到右上角
    _drawDashedLine(canvas, paint, Offset(0, 0), Offset(size.width, 0));
    
    // 绘制右边：从右上角到右下角
    _drawDashedLine(canvas, paint, Offset(size.width, 0), Offset(size.width, size.height));
    
    // 绘制下边：从右下角到左下角
    _drawDashedLine(canvas, paint, Offset(size.width, size.height), Offset(0, size.height));
    
    // 绘制左边：从左下角到左上角
    _drawDashedLine(canvas, paint, Offset(0, size.height), Offset(0, 0));
  }

  /// 绘制圆角虚线边框
  /// 使用 Path 和 PathMetric 来处理圆角路径上的虚线绘制
  void _drawDashedRoundedRect(Canvas canvas, Size size, Paint paint) {
    // 创建矩形区域
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // 创建圆角矩形
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    
    // 创建路径并添加圆角矩形
    final path = Path()..addRRect(rrect);
    
    // 获取路径的测量信息，用于计算沿路径的位置
    final pathMetrics = path.computeMetrics();
    
    // 遍历路径的每个部分（通常圆角矩形只有一个连续路径）
    for (final pathMetric in pathMetrics) {
      final totalLength = pathMetric.length;  // 路径的总长度
      double distance = 0;                    // 当前绘制位置
      
      // 沿着路径绘制虚线
      while (distance < totalLength) {
        final startDistance = distance;                              // 当前虚线段的起始位置
        final endDistance = math.min(distance + dashLength, totalLength);  // 当前虚线段的结束位置
        
        // 获取起始位置和结束位置的切线信息（包含位置和方向）
        final startTangent = pathMetric.getTangentForOffset(startDistance);
        final endTangent = pathMetric.getTangentForOffset(endDistance);
        
        // 如果成功获取到位置信息，就绘制这一段虚线
        if (startTangent != null && endTangent != null) {
          canvas.drawLine(startTangent.position, endTangent.position, paint);
        }
        
        // 移动到下一个虚线段的位置（跳过间隔）
        distance += dashLength + gapLength;
      }
    }
  }

  /// 绘制一条虚线
  /// 在起始点和结束点之间��制虚线
  /// start: 起始点坐标
  /// end: 结束点坐标
  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    // 计算起始点到结束点的总距离
    final totalDistance = (end - start).distance;
    
    // 计算单位向量（方向向量，长度为1）
    final unitVector = (end - start) / totalDistance;
    
    double currentDistance = 0;  // 当前绘制位置
    
    // 沿着直线绘制虚线段
    while (currentDistance < totalDistance) {
      // 计算当前虚线段的起始点
      final segmentStart = start + unitVector * currentDistance;
      
      // 计算当前虚线段的结束点（不能超过总长度）
      final segmentEnd = start + unitVector * math.min(currentDistance + dashLength, totalDistance);
      
      // 绘制这一段虚线
      canvas.drawLine(segmentStart, segmentEnd, paint);
      
      // 移动到下一个虚线段的位置（跳过间隔）
      currentDistance += dashLength + gapLength;
    }
  }

  /// 判断是否需要重新绘制
  /// 这里返回 false，表示绘制器的参数不会动态改变，不需要重绘
  /// 如果你的绘制器有动画效果，可以返回 true
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 虚线边框容器组件
/// 
/// 这是一个封装好的容器组件，可以直接使用，无需手动处理 CustomPaint
/// 提供了丰富的自定义选项，让你轻松创建各种样式的虚线边框容器
/// 
/// 使用示例:
/// ```dart
/// DashedContainer(
///   width: 200,
///   height: 100,
///   padding: EdgeInsets.all(16),
///   borderColor: Colors.blue,
///   strokeWidth: 2,
///   dashLength: 8,
///   gapLength: 4,
///   borderRadius: 12,
///   backgroundColor: Colors.blue.shade50,
///   child: Text('这是容器内容'),
/// )
/// ```
class DashedContainer extends StatelessWidget {
  /// 容器内的子组件
  final Widget child;
  
  /// 容器的宽度（可选，不设置则自适应）
  final double? width;
  
  /// 容器的高度（可选，不设置则自适应）
  final double? height;
  
  /// 容器内容的内边距
  final EdgeInsetsGeometry? padding;
  
  /// 容器的外边距
  final EdgeInsetsGeometry? margin;
  
  /// 虚线边框的颜色
  final Color borderColor;
  
  /// 虚线的粗细程度
  final double strokeWidth;
  
  /// 每段虚线的长度
  final double dashLength;
  
  /// 虚线段之间的间隔长度
  final double gapLength;
  
  /// 容器的圆角半径（0表示直角）
  final double borderRadius;
  
  /// 容器的背景颜色（可选）
  final Color? backgroundColor;

  /// 构造函数
  /// 
  /// [child] 必填参数，容器内要显示的内容
  /// [width] 和 [height] 可选，不设置��容器会根据内容自适应大小
  /// [padding] 内边距，影响子组件与边框的距离
  /// [margin] 外边距，影响整个容器与外部组件的距离
  /// [borderColor] 虚线颜色，默认灰色
  /// [strokeWidth] 线条粗细，默认1像素
  /// [dashLength] 虚线段长度，默认5像素
  /// [gapLength] 虚线间隔，默认3像素
  /// [borderRadius] 圆角大小，默���0（直角）
  /// [backgroundColor] 背景色，默认透明
  const DashedContainer({
    super.key,
    required this.child,                    // 必须提供子组件
    this.width,                            // 可选宽度
    this.height,                           // 可选高度
    this.padding,                          // 可选内边距
    this.margin,                           // 可选外边距
    this.borderColor = Colors.grey,        // 默认灰色边框
    this.strokeWidth = 1.0,                // 默认1像素线宽
    this.dashLength = 5.0,                 // 默认5像素虚线段
    this.gapLength = 3.0,                  // 默认3像素间隔
    this.borderRadius = 0.0,               // 默认直角
    this.backgroundColor,                  // 可选背景色
  });

  /// 构建UI的方法
  /// 这是 StatelessWidget 必须实现的方法
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,           // 设置容器宽度
      height: height,         // 设置容器高度
      margin: margin,         // 设置外边距
      child: CustomPaint(
        // 使用我们自定义的虚线绘制器
        painter: DashedBorderPainter(
          color: borderColor,           // 传递边框颜色
          strokeWidth: strokeWidth,     // 传递线条粗细
          dashLength: dashLength,       // 传递虚线段长度
          gapLength: gapLength,         // 传递间隔长度
          borderRadius: borderRadius,   // 传递圆角半径
        ),
        child: Container(
          // 设置内边距，如果没有指定就使用线宽作为默认内边距
          // 这样可以确保内容不会与边框重叠
          padding: padding ?? EdgeInsets.all(strokeWidth),
          
          // 如果指定了背景色，就设置容器的装饰
          decoration: backgroundColor != null
              ? BoxDecoration(
                  color: backgroundColor,           // 设置背景色
                  borderRadius: borderRadius > 0   // 如果有圆角就应用圆角
                      ? BorderRadius.circular(borderRadius)
                      : null,
                )
              : null,  // 没有背景色就不设置装饰
          
          child: child,  // 显示传入的子组件
        ),
      ),
    );
  }
}