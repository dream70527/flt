import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double borderRadius;

  const DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.dashLength = 5.0,
    this.gapLength = 3.0,
    this.borderRadius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (borderRadius > 0) {
      _drawDashedRoundedRect(canvas, size, paint);
    } else {
      _drawDashedRect(canvas, size, paint);
    }
  }

  void _drawDashedRect(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    
    // Top line
    _drawDashedLine(canvas, paint, Offset(0, 0), Offset(size.width, 0));
    // Right line
    _drawDashedLine(canvas, paint, Offset(size.width, 0), Offset(size.width, size.height));
    // Bottom line
    _drawDashedLine(canvas, paint, Offset(size.width, size.height), Offset(0, size.height));
    // Left line
    _drawDashedLine(canvas, paint, Offset(0, size.height), Offset(0, 0));
  }

  void _drawDashedRoundedRect(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();
    
    for (final pathMetric in pathMetrics) {
      final totalLength = pathMetric.length;
      double distance = 0;
      
      while (distance < totalLength) {
        final startDistance = distance;
        final endDistance = math.min(distance + dashLength, totalLength);
        
        final startTangent = pathMetric.getTangentForOffset(startDistance);
        final endTangent = pathMetric.getTangentForOffset(endDistance);
        
        if (startTangent != null && endTangent != null) {
          canvas.drawLine(startTangent.position, endTangent.position, paint);
        }
        
        distance += dashLength + gapLength;
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    final totalDistance = (end - start).distance;
    final unitVector = (end - start) / totalDistance;
    
    double currentDistance = 0;
    while (currentDistance < totalDistance) {
      final segmentStart = start + unitVector * currentDistance;
      final segmentEnd = start + unitVector * math.min(currentDistance + dashLength, totalDistance);
      
      canvas.drawLine(segmentStart, segmentEnd, paint);
      currentDistance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LayoutDemoPage extends StatelessWidget {
  const LayoutDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 布局演示'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLayoutSection(
            '1. Container - 容器布局',
            'Container(\n  width: 200,\n  height: 100,\n  color: Colors.blue,\n  child: Center(child: Text("Container")),\n)',
            Container(
              width: 200,
              height: 100,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Container',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          _buildLayoutSection(
            '2. Row - 水平排列',
            'Row(\n  mainAxisAlignment: MainAxisAlignment.spaceAround,\n  children: [\n    Container(...),\n    Container(...),\n    Container(...),\n  ],\n)',
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.red,
                  child: const Center(child: Text('1', style: TextStyle(color: Colors.white))),
                ),
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.green,
                  child: const Center(child: Text('2', style: TextStyle(color: Colors.white))),
                ),
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.orange,
                  child: const Center(child: Text('3', style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
          _buildLayoutSection(
            '3. Column - 垂直排列',
            'Column(\n  mainAxisAlignment: MainAxisAlignment.spaceEvenly,\n  children: [\n    Container(...),\n    Container(...),\n  ],\n)',
            SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 60,
                    color: Colors.purple,
                    child: const Center(child: Text('Item 1', style: TextStyle(color: Colors.white))),
                  ),
                  Container(
                    width: 150,
                    height: 60,
                    color: Colors.teal,
                    child: const Center(child: Text('Item 2', style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            ),
          ),
          _buildLayoutSection(
            '4. Stack - 层叠布局',
            'Stack(\n  children: [\n    Container(...), // 底层\n    Positioned(\n      top: 20, left: 20,\n      child: Container(...), // 顶层\n    ),\n  ],\n)',
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 120,
                    color: Colors.blue.shade200,
                    child: const Center(child: Text('底层')),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: 100,
                      height: 60,
                      color: Colors.red.shade400,
                      child: const Center(
                        child: Text('顶层', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildLayoutSection(
            '5. Wrap - 自动换行',
            'Wrap(\n  spacing: 10,\n  runSpacing: 10,\n  children: [\n    Chip(label: Text("Tag1")),\n    Chip(label: Text("Tag2")),\n    ...\n  ],\n)',
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(label: const Text('Flutter'), backgroundColor: Colors.blue.shade100),
                Chip(label: const Text('Dart'), backgroundColor: Colors.green.shade100),
                Chip(label: const Text('Mobile'), backgroundColor: Colors.orange.shade100),
                Chip(label: const Text('UI'), backgroundColor: Colors.purple.shade100),
                Chip(label: const Text('Layout'), backgroundColor: Colors.teal.shade100),
                Chip(label: const Text('Widget'), backgroundColor: Colors.red.shade100),
              ],
            ),
          ),
          _buildLayoutSection(
            '6. Expanded - 弹性扩展',
            'Row(\n  children: [\n    Expanded(flex: 1, child: Container(...)),\n    Expanded(flex: 2, child: Container(...)),\n    Expanded(flex: 1, child: Container(...)),\n  ],\n)',
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.red.shade300,
                      child: const Center(child: Text('1', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.green.shade300,
                      child: const Center(child: Text('2', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.blue.shade300,
                      child: const Center(child: Text('1', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildLayoutSection(
            '7. GridView - 网格布局',
            'GridView.count(\n  crossAxisCount: 3,\n  children: [\n    Container(...),\n    Container(...),\n    ...\n  ],\n)',
            SizedBox(
              height: 200,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(6, (index) {
                  final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.teal];
                  return Container(
                    color: colors[index].shade300,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          _buildLayoutSection(
            '8. Card - 卡片布局',
            'Card(\n  elevation: 4,\n  child: Padding(\n    padding: EdgeInsets.all(16),\n    child: Column(...),\n  ),\n)',
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade600),
                        const SizedBox(width: 8),
                        const Text('卡片标题', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('这是卡片的内容区域，可以放置各种信息和组件。'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {}, child: const Text('取消')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: () {}, child: const Text('确定')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildLayoutSection(
            '9. ListTile - 列表项',
            'ListTile(\n  leading: Icon(Icons.person),\n  title: Text("标题"),\n  subtitle: Text("副标题"),\n  trailing: Icon(Icons.arrow_forward),\n)',
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue.shade600),
                    title: const Text('用户信息'),
                    subtitle: const Text('点击查看详细信息'),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.green.shade600),
                    title: const Text('设置'),
                    subtitle: const Text('应用程序设置'),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          _buildLayoutSection(
            '10. Padding - 内边距',
            'Padding(\n  padding: EdgeInsets.all(20),\n  child: Container(\n    color: Colors.blue,\n    child: Text("有内边距的容器"),\n  ),\n)',
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text(
                      '有内边距的容器',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildLayoutSection(
            '11. 虚线边框容器 - DashedBorder',
            'Container(\n  decoration: BoxDecoration(\n    border: Border.all(\n      color: Colors.blue,\n      width: 2,\n      strokeAlign: BorderSide.strokeAlignInside,\n    ),\n    borderRadius: BorderRadius.circular(12),\n  ),\n  child: CustomPaint(\n    painter: DashedBorderPainter(),\n    child: Container(...),\n  ),\n)',
            Column(
              children: [
                Container(
                  width: 250,
                  height: 120,
                  child: CustomPaint(
                    painter: DashedBorderPainter(
                      color: Colors.blue,
                      strokeWidth: 2,
                      dashLength: 8,
                      gapLength: 4,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text(
                          '虚线边框容器',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 250,
                  height: 120,
                  child: CustomPaint(
                    painter: DashedBorderPainter(
                      color: Colors.red,
                      strokeWidth: 3,
                      dashLength: 12,
                      gapLength: 6,
                      borderRadius: 16,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(
                        child: Text(
                          '圆角虚线边框',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutSection(String title, String code, Widget demo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: demo,
            ),
          ],
        ),
      ),
    );
  }
}