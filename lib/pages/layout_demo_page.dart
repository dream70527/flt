import 'package:flutter/material.dart';

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