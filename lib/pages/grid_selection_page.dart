import 'package:flutter/material.dart';

class GridSelectionPage extends StatefulWidget {
  const GridSelectionPage({Key? key}) : super(key: key);

  @override
  State<GridSelectionPage> createState() => _GridSelectionPageState();
}

class _GridSelectionPageState extends State<GridSelectionPage> {
  List<int> selectedItems = [];

  void toggleSelection(int index) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网格选择示例'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '已选择: ${selectedItems.length} 项',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 一行两个
                childAspectRatio: 166/40, // 宽高比
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                bool isSelected = selectedItems.contains(index);
                
                return GestureDetector(
                  onTap: () => toggleSelection(index),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade50, // 选中亮色背景
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.transparent, // 边框颜色
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              if (isSelected) const SizedBox(width: 8),
                              Text(
                                '选项 ${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.blue : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 右上角悬浮部件
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 24,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            if (selectedItems.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '选中的项目:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: selectedItems.map((index) => Chip(
                        label: Text('选项 ${index + 1}'),
                        backgroundColor: Colors.blue.shade100,
                        side: BorderSide(color: Colors.blue),
                      )).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}