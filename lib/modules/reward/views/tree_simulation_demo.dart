import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

/// 模拟Flutter三棵树关系的对象
class TreeRelationshipSimulator {
  static TreeNode simulateFlutterTrees() {
    // 模拟一个实际的Flutter Widget结构
    return TreeNode(
      widgetData: MyWidget(type: 'Scaffold', props: {'title': 'My App'}),
      elementData: MyElement(id: 'scaffold_001', type: 'ScaffoldElement'),
      renderObjectData: null, // Scaffold没有RenderObject
      children: [
        // AppBar子树
        TreeNode(
          widgetData: MyWidget(type: 'AppBar', props: {'title': 'Hello Flutter'}),
          elementData: MyElement(id: 'appbar_001', type: 'AppBarElement'),
          renderObjectData: MyRenderObject(id: 'render_appbar_001', type: 'RenderSliver', size: Size(400, 56)),
          children: [
            TreeNode(
              widgetData: MyWidget(type: 'Text', props: {'text': 'Hello Flutter'}),
              elementData: MyElement(id: 'text_001', type: 'TextElement'),
              renderObjectData: MyRenderObject(id: 'render_text_001', type: 'RenderParagraph', size: Size(120, 20)),
            ),
          ],
        ),
        // Body子树
        TreeNode(
          widgetData: MyWidget(type: 'Column', props: {'mainAxisAlignment': 'center'}),
          elementData: MyElement(id: 'column_001', type: 'ColumnElement'),
          renderObjectData: MyRenderObject(id: 'render_column_001', type: 'RenderFlex', size: Size(400, 600)),
          children: [
            // 第一个Text
            TreeNode(
              widgetData: MyWidget(type: 'Text', props: {'text': 'Welcome to Flutter'}),
              elementData: MyElement(id: 'text_002', type: 'TextElement'),
              renderObjectData: MyRenderObject(id: 'render_text_002', type: 'RenderParagraph', size: Size(200, 24)),
            ),
            // Container包装的按钮
            TreeNode(
              widgetData: MyWidget(type: 'Container', props: {'margin': '16px', 'padding': '8px'}),
              elementData: MyElement(id: 'container_001', type: 'ContainerElement'),
              renderObjectData: MyRenderObject(id: 'render_container_001', type: 'RenderDecoratedBox', size: Size(150, 60)),
              children: [
                TreeNode(
                  widgetData: MyWidget(type: 'ElevatedButton', props: {'text': 'Click Me'}),
                  elementData: MyElement(id: 'button_001', type: 'ElevatedButtonElement'),
                  renderObjectData: MyRenderObject(id: 'render_button_001', type: 'RenderBox', size: Size(120, 40)),
                  children: [
                    TreeNode(
                      widgetData: MyWidget(type: 'Text', props: {'text': 'Click Me'}),
                      elementData: MyElement(id: 'text_003', type: 'TextElement'),
                      renderObjectData: MyRenderObject(id: 'render_text_003', type: 'RenderParagraph', size: Size(80, 16)),
                    ),
                  ],
                ),
              ],
            ),
            // Icon
            TreeNode(
              widgetData: MyWidget(type: 'Icon', props: {'icon': 'Icons.favorite', 'size': 32}),
              elementData: MyElement(id: 'icon_001', type: 'IconElement'),
              renderObjectData: MyRenderObject(id: 'render_icon_001', type: 'RenderImage', size: Size(32, 32)),
            ),
          ],
        ),
      ],
    );
  }
}

/// 模拟Widget对象
class MyWidget {
  final String type;
  final Map<String, dynamic> props;
  final String id;

  MyWidget({
    required this.type,
    required this.props,
  }) : id = 'widget_${DateTime.now().microsecondsSinceEpoch}';

  @override
  String toString() => '$type(${props.entries.map((e) => '${e.key}: ${e.value}').join(', ')})';
}

/// 模拟Element对象
class MyElement {
  final String id;
  final String type;
  MyWidget? widget;      // 指向对应的Widget
  MyRenderObject? renderObject; // 指向对应的RenderObject
  MyElement? parent;     // 父Element
  List<MyElement> children = []; // 子Element列表
  DateTime createdAt;
  int rebuildCount = 0;

  MyElement({
    required this.id,
    required this.type,
    this.widget,
    this.renderObject,
  }) : createdAt = DateTime.now();

  void updateWidget(MyWidget newWidget) {
    widget = newWidget;
    rebuildCount++;
  }

  @override
  String toString() => '$type($id) [rebuilds: $rebuildCount]';
}

/// 模拟RenderObject对象
class MyRenderObject {
  final String id;
  final String type;
  final Size size;
  Offset position;
  MyRenderObject? parent;
  List<MyRenderObject> children = [];
  bool needsLayout = false;
  bool needsPaint = false;

  MyRenderObject({
    required this.id,
    required this.type,
    required this.size,
    this.position = Offset.zero,
  });

  void performLayout() {
    needsLayout = false;
    print('📐 Layout: $type ($id) - Size: $size, Position: $position');
  }

  void paint() {
    needsPaint = false;
    print('🎨 Paint: $type ($id) - Drawing at $position with size $size');
  }

  @override
  String toString() => '$type($id) [${size.width.toInt()}x${size.height.toInt()}]';
}

/// 树节点 - 连接三棵树的桥梁
class TreeNode {
  final MyWidget widgetData;
  final MyElement elementData;
  final MyRenderObject? renderObjectData;
  final List<TreeNode> children;

  TreeNode({
    required this.widgetData,
    required this.elementData,
    this.renderObjectData,
    this.children = const [],
  }) {
    // 建立引用关系
    elementData.widget = widgetData;
    elementData.renderObject = renderObjectData;
    
    // 建立父子关系
    for (var child in children) {
      elementData.children.add(child.elementData);
      child.elementData.parent = elementData;
      
      if (renderObjectData != null && child.renderObjectData != null) {
        renderObjectData!.children.add(child.renderObjectData!);
        child.renderObjectData!.parent = renderObjectData;
      }
    }
  }

  /// 模拟Widget重建过程
  void simulateRebuild(Map<String, dynamic> newProps) {
    print('\n🔄 开始重建 ${widgetData.type}...');
    
    // 1. 创建新Widget
    final newWidget = MyWidget(type: widgetData.type, props: newProps);
    print('1️⃣ 创建新Widget: $newWidget');
    
    // 2. Element比较新旧Widget
    if (widgetData.type == newWidget.type) {
      elementData.updateWidget(newWidget);
      print('2️⃣ Element复用，更新Widget引用');
    } else {
      print('2️⃣ Widget类型变化，需要重建Element');
    }
    
    // 3. 更新RenderObject
    if (renderObjectData != null) {
      renderObjectData!.needsLayout = true;
      renderObjectData!.needsPaint = true;
      print('3️⃣ 标记RenderObject需要重新布局和绘制');
    }
    
    print('✅ 重建完成\n');
  }

  /// 模拟渲染流程
  void simulateRenderPipeline() {
    print('\n🚀 开始渲染流程...');
    _performLayout();
    _performPaint();
    print('✅ 渲染完成\n');
  }

  void _performLayout() {
    print('\n📐 Layout阶段：');
    _traverseAndLayout(this);
  }

  void _performPaint() {
    print('\n🎨 Paint阶段：');
    _traverseAndPaint(this);
  }

  void _traverseAndLayout(TreeNode node) {
    node.renderObjectData?.performLayout();
    for (var child in node.children) {
      _traverseAndLayout(child);
    }
  }

  void _traverseAndPaint(TreeNode node) {
    node.renderObjectData?.paint();
    for (var child in node.children) {
      _traverseAndPaint(child);
    }
  }

  /// 打印三棵树的完整结构
  void printTreeStructures() {
    print('\n🌳 Flutter三棵树结构对比：');
    print('═' * 80);
    
    print('\n🔵 Widget Tree:');
    _printWidgetTree(this, 0);
    
    print('\n🟡 Element Tree:');
    _printElementTree(this, 0);
    
    print('\n🟢 RenderObject Tree:');
    _printRenderObjectTree(this, 0);
    
    print('\n' + '═' * 80);
  }

  /// 获取完整的数据结构展示
  Map<String, dynamic> getCompleteStructure() {
    return _buildCompleteNode(this);
  }

  Map<String, dynamic> _buildCompleteNode(TreeNode node) {
    final Map<String, dynamic> structure = {
      'widget': {
        'id': node.widgetData.id,
        'type': node.widgetData.type,
        'props': node.widgetData.props,
      },
      'element': {
        'id': node.elementData.id,
        'type': node.elementData.type,
        'rebuildCount': node.elementData.rebuildCount,
        'createdAt': node.elementData.createdAt.toIso8601String(),
        'widgetReference': node.elementData.widget?.id,
        'renderObjectReference': node.elementData.renderObject?.id,
        'parentId': node.elementData.parent?.id,
        'childrenIds': node.elementData.children.map((e) => e.id).toList(),
      },
    };

    if (node.renderObjectData != null) {
      structure['renderObject'] = {
        'id': node.renderObjectData!.id,
        'type': node.renderObjectData!.type,
        'size': '${node.renderObjectData!.size.width}x${node.renderObjectData!.size.height}',
        'position': '${node.renderObjectData!.position.dx},${node.renderObjectData!.position.dy}',
        'parentId': node.renderObjectData!.parent?.id,
        'childrenIds': node.renderObjectData!.children.map((r) => r.id).toList(),
      };
    } else {
      structure['renderObject'] = null;
    }

    if (node.children.isNotEmpty) {
      structure['children'] = node.children.map((child) => _buildCompleteNode(child)).toList();
    }

    return structure;
  }

  void _printWidgetTree(TreeNode node, int depth) {
    final indent = '  ' * depth;
    print('$indent├─ ${node.widgetData}');
    for (var child in node.children) {
      _printWidgetTree(child, depth + 1);
    }
  }

  void _printElementTree(TreeNode node, int depth) {
    final indent = '  ' * depth;
    final hasRenderObject = node.renderObjectData != null ? '→RO' : '→∅';
    print('$indent├─ ${node.elementData} $hasRenderObject');
    for (var child in node.children) {
      _printElementTree(child, depth + 1);
    }
  }

  void _printRenderObjectTree(TreeNode node, int depth) {
    if (node.renderObjectData != null) {
      final indent = '  ' * depth;
      print('$indent├─ ${node.renderObjectData}');
    }
    for (var child in node.children) {
      _printRenderObjectTree(child, node.renderObjectData != null ? depth + 1 : depth);
    }
  }
}

/// 演示页面
class TreeSimulationDemo extends StatefulWidget {
  const TreeSimulationDemo({super.key});

  @override
  State<TreeSimulationDemo> createState() => _TreeSimulationDemoState();
}

class _TreeSimulationDemoState extends State<TreeSimulationDemo> {
  late TreeNode rootNode;
  List<String> logs = [];
  String? jsonStructure;
  bool showJsonStructure = false;

  @override
  void initState() {
    super.initState();
    _initializeTree();
  }

  void _initializeTree() {
    rootNode = TreeRelationshipSimulator.simulateFlutterTrees();
    _addLog('🌳 初始化Flutter三棵树结构完成');
  }

  void _addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter三棵树关系模拟'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                logs.clear();
                _initializeTree();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 控制面板
            _buildControlPanel(),
            
            SizedBox(height: 20.h),
            
            // 树结构可视化
            _buildTreeVisualization(),
            
            SizedBox(height: 20.h),
            
            // JSON结构展示
            _buildJsonStructurePanel(),
            
            SizedBox(height: 20.h),
            
            // 日志面板
            _buildLogPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎮 控制面板',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            Wrap(
              spacing: 8.w,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _addLog('📊 打印三棵树结构');
                    rootNode.printTreeStructures();
                  },
                  icon: Icon(Icons.account_tree, size: 16.w),
                  label: Text('打印树结构'),
                ),
                
                ElevatedButton.icon(
                  onPressed: () {
                    _addLog('📋 生成JSON结构');
                    final structure = rootNode.getCompleteStructure();
                    setState(() {
                      jsonStructure = JsonEncoder.withIndent('  ').convert(structure);
                      showJsonStructure = true;
                    });
                  },
                  icon: Icon(Icons.code, size: 16.w),
                  label: Text('JSON结构'),
                ),
                
                ElevatedButton.icon(
                  onPressed: () {
                    _addLog('🔄 模拟Widget重建');
                    rootNode.children[1].simulateRebuild({
                      'mainAxisAlignment': 'start',
                      'backgroundColor': 'Colors.blue'
                    });
                  },
                  icon: Icon(Icons.refresh, size: 16.w),
                  label: Text('模拟重建'),
                ),
                
                ElevatedButton.icon(
                  onPressed: () {
                    _addLog('🎨 模拟渲染流程');
                    rootNode.simulateRenderPipeline();
                  },
                  icon: Icon(Icons.play_arrow, size: 16.w),
                  label: Text('模拟渲染'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeVisualization() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌳 树结构可视化',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // 简化的树结构展示
            _buildSimplifiedTreeView(rootNode, 0),
          ],
        ),
      ),
    );
  }

  Widget _buildJsonStructurePanel() {
    if (!showJsonStructure || jsonStructure == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(Icons.code, size: 48.w, color: Colors.grey),
            SizedBox(height: 10.h),
            Text(
              '点击"JSON结构"按钮查看完整的数据结构关系',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '🔗 完整数据结构关系',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      showJsonStructure = false;
                      jsonStructure = null;
                    });
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 关键理解：',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• Element.widgetReference → 指向对应Widget的ID\n'
                    '• Element.renderObjectReference → 指向对应RenderObject的ID\n'  
                    '• Element.parentId 和 childrenIds → 建立父子关系\n'
                    '• children数组 → 展示树的嵌套结构',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Container(
              height: 400.h,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(12.w),
                child: SelectableText(
                  jsonStructure!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Courier',
                    color: Colors.green.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplifiedTreeView(TreeNode node, int depth) {
    final indent = depth * 20.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: indent, bottom: 8.h),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: _getNodeColor(node.widgetData.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: _getNodeColor(node.widgetData.type).withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getNodeIcon(node.widgetData.type),
                    size: 16.w,
                    color: _getNodeColor(node.widgetData.type),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    node.widgetData.type,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  if (node.renderObjectData != null)
                    Icon(Icons.check_circle, size: 14.w, color: Colors.green)
                  else
                    Icon(Icons.remove_circle, size: 14.w, color: Colors.grey),
                ],
              ),
              
              if (depth < 2) // 只显示前两层的详细信息
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Element: ${node.elementData.type} (${node.elementData.id})',
                        style: TextStyle(fontSize: 10.sp, color: Colors.orange),
                      ),
                      if (node.renderObjectData != null)
                        Text(
                          'RenderObject: ${node.renderObjectData!.type} (${node.renderObjectData!.id})',
                          style: TextStyle(fontSize: 10.sp, color: Colors.green),
                        ),
                      
                      // 显示引用关系
                      if (depth == 0)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade100,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '引用关系：\n'
                              '• Element → Widget: ${node.elementData.widget?.id}\n'
                              '• Element → RenderObject: ${node.elementData.renderObject?.id ?? "null"}\n'
                              '• 子节点数: ${node.children.length}',
                              style: TextStyle(fontSize: 9.sp, color: Colors.orange.shade800),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        ...node.children.map((child) => _buildSimplifiedTreeView(child, depth + 1)),
      ],
    );
  }

  Color _getNodeColor(String type) {
    switch (type) {
      case 'Scaffold': return Colors.purple;
      case 'AppBar': return Colors.blue;
      case 'Column': return Colors.orange;
      case 'Text': return Colors.green;
      case 'ElevatedButton': return Colors.red;
      case 'Container': return Colors.brown;
      case 'Icon': return Colors.pink;
      default: return Colors.grey;
    }
  }

  IconData _getNodeIcon(String type) {
    switch (type) {
      case 'Scaffold': return Icons.web_asset;
      case 'AppBar': return Icons.title;
      case 'Column': return Icons.view_column;
      case 'Text': return Icons.text_fields;
      case 'ElevatedButton': return Icons.smart_button;
      case 'Container': return Icons.crop_square;
      case 'Icon': return Icons.image;
      default: return Icons.widgets;
    }
  }

  Widget _buildLogPanel() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '📝 操作日志',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      logs.clear();
                    });
                  },
                  child: Text('清空日志'),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        '暂无日志记录',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          child: Text(
                            logs[index],
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'monospace',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}