import 'package:flutter/material.dart';
import '../widgets/dashed_container.dart';

class DashedContainerDemo extends StatelessWidget {
  const DashedContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('虚线边框容器演示'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '基础虚线边框',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DashedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              borderColor: Colors.blue,
              strokeWidth: 2,
              dashLength: 8,
              gapLength: 4,
              child: const Text(
                '这是一个基础的虚线边框容器',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              '圆角虚线边框',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DashedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              borderColor: Colors.green,
              backgroundColor: Colors.green.shade50,
              strokeWidth: 2,
              dashLength: 10,
              gapLength: 5,
              borderRadius: 12,
              child: const Text(
                '这是一个带圆角和背景色的虚线边框容器',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              '不同样式的虚线边框',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DashedContainer(
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    borderColor: Colors.red,
                    strokeWidth: 3,
                    dashLength: 15,
                    gapLength: 8,
                    borderRadius: 8,
                    child: const Center(
                      child: Text(
                        '粗虚线',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashedContainer(
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    borderColor: Colors.purple,
                    strokeWidth: 1,
                    dashLength: 3,
                    gapLength: 2,
                    borderRadius: 8,
                    child: const Center(
                      child: Text(
                        '细密虚线',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text(
              '带图标的虚线边框卡片',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DashedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              borderColor: Colors.orange,
              backgroundColor: Colors.orange.shade50,
              strokeWidth: 2,
              dashLength: 12,
              gapLength: 6,
              borderRadius: 16,
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '拖拽文件到此处上传',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '支持 PNG、JPG、PDF 格式',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              '使用方法:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''DashedContainer(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  borderColor: Colors.blue,
  strokeWidth: 2,
  dashLength: 8,
  gapLength: 4,
  borderRadius: 12,
  backgroundColor: Colors.blue.shade50,
  child: Text('内容'),
)''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}