import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 带动画效果的自定义下拉组件
/// 
/// 功能特性：
/// - 流畅的下拉展开/收起动画
/// - 箭头旋转动画效果（180度）
/// - 点击外部区域自动收起
/// - 支持图标和自定义样式
/// - 选中状态高亮显示
/// - 支持长列表滚动
/// - 完全自定义外观
class AnimatedDropdown extends StatefulWidget {
  /// 下拉选项列表
  final List<DropdownItem> items;
  /// 当前选中的值
  final DropdownItem? value;
  /// 选择变化回调
  final ValueChanged<DropdownItem?>? onChanged;
  /// 提示文本
  final String hint;
  /// 组件宽度（默认自适应）
  final double? width;
  /// 组件高度
  final double height;
  /// 背景颜色
  final Color? backgroundColor;
  /// 边框颜色
  final Color? borderColor;
  /// 圆角半径
  final BorderRadius? borderRadius;
  /// 文本样式
  final TextStyle? textStyle;
  /// 提示文本样式
  final TextStyle? hintStyle;
  /// 动画持续时间
  final Duration animationDuration;
  /// 下拉列表最大高度
  final double maxDropdownHeight;

  const AnimatedDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint = '请选择',
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.textStyle,
    this.hintStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maxDropdownHeight = 200,
  });

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown>
    with TickerProviderStateMixin {
  /// 下拉框是否展开
  bool _isExpanded = false;
  /// 下拉动画控制器
  late AnimationController _dropdownController;
  /// 箭头旋转动画控制器
  late AnimationController _arrowController;
  /// 下拉展开动画
  late Animation<double> _dropdownAnimation;
  /// 箭头旋转动画
  late Animation<double> _arrowAnimation;
  
  /// 下拉框组件的GlobalKey，用于获取位置信息
  final GlobalKey _dropdownKey = GlobalKey();
  /// 覆盖层入口，用于显示下拉列表
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  /// 初始化动画控制器和动画
  void _initAnimations() {
    // 下拉动画控制器 - 控制下拉列表的展开/收起
    _dropdownController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    // 箭头旋转动画控制器 - 控制右侧箭头的旋转
    _arrowController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // 下拉动画 - 使用缓动曲线，从0到1的缩放和透明度变化
    _dropdownAnimation = CurvedAnimation(
      parent: _dropdownController,
      curve: Curves.easeOutCubic, // 使用缓出三次贝塞尔曲线
    );

    // 箭头旋转动画 - 180度旋转效果
    _arrowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5, // 0.5表示180度 (0.5 * 2 * π = π弧度 = 180度)
    ).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut, // 缓入缓出曲线
    ));
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    _arrowController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _dropdownKey,
      width: widget.width,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: widget.height.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            border: Border.all(
              color: widget.borderColor ?? Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.value?.label ?? widget.hint,
                  style: widget.value != null
                      ? (widget.textStyle ?? TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ))
                      : (widget.hintStyle ?? TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        )),
                ),
              ),
              
              // 带旋转动画的箭头图标
              AnimatedBuilder(
                animation: _arrowAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _arrowAnimation.value * 2 * 3.14159, // 转换为弧度 (π ≈ 3.14159)
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                      size: 24.w,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 切换下拉框展开/收起状态
  void _toggleDropdown() {
    if (_isExpanded) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  /// 打开下拉框
  void _openDropdown() {
    setState(() {
      _isExpanded = true;
    });

    // 启动动画 - 箭头旋转和下拉展开同时进行
    _arrowController.forward();
    _dropdownController.forward();

    // 创建覆盖层显示下拉列表
    _createOverlay();
  }

  /// 关闭下拉框
  void _closeDropdown() {
    setState(() {
      _isExpanded = false;
    });

    // 反向动画 - 箭头复位和下拉收起
    _arrowController.reverse();
    _dropdownController.reverse().then((_) {
      // 动画完成后移除覆盖层
      _removeOverlay();
    });
  }

  /// 创建覆盖层显示下拉列表
  void _createOverlay() {
    _removeOverlay();

    // 获取下拉框的尺寸和位置信息
    final RenderBox renderBox = 
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown, // 点击外部区域关闭下拉框
        behavior: HitTestBehavior.translucent, // 透明区域也能接收点击事件
        child: Stack(
          children: [
            // 全屏透明遮罩 - 用于捕获外部点击事件
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // 下拉列表定位容器
            Positioned(
              left: offset.dx, // 与下拉框左边缘对齐
              top: offset.dy + size.height + 4, // 位于下拉框下方，间距4像素
              width: size.width, // 与下拉框同宽
              child: GestureDetector(
                onTap: () {}, // 阻止事件冒泡到外部遮罩
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedBuilder(
                    animation: _dropdownAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _dropdownAnimation.value, // 缩放动画
                        alignment: Alignment.topCenter, // 从顶部中心缩放
                        child: Opacity(
                          opacity: _dropdownAnimation.value, // 透明度动画
                          child: _buildDropdownList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 将覆盖层插入到当前页面的覆盖层栈中
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 构建下拉列表UI
  Widget _buildDropdownList() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.maxDropdownHeight.h, // 限制最大高度，超出时可滚动
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        // 添加阴影效果
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4), // 向下偏移4像素
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = widget.value == item;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectItem(item), // 点击选择项目
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      // 选中项高亮显示
                      color: isSelected 
                          ? Colors.blue.shade50
                          : Colors.transparent,
                      // 除最后一项外都添加分割线
                      border: index != widget.items.length - 1
                          ? Border(bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ))
                          : null,
                    ),
                    child: Row(
                      children: [
                        // 显示图标（如果有）
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            size: 20.w,
                            color: isSelected 
                                ? Colors.blue 
                                : Colors.grey.shade600,
                          ),
                          SizedBox(width: 12.w),
                        ],
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isSelected 
                                  ? Colors.blue 
                                  : Colors.black87,
                              fontWeight: isSelected 
                                  ? FontWeight.w500 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        // 选中项显示勾选图标
                        if (isSelected)
                          Icon(
                            Icons.check,
                            size: 18.w,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// 选择下拉项并关闭下拉框
  void _selectItem(DropdownItem item) {
    widget.onChanged?.call(item);
    _closeDropdown();
  }

  /// 移除覆盖层
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// 下拉选项数据类
/// 
/// 用于定义下拉框中的每个选项
class DropdownItem {
  /// 选项的唯一标识值
  final String value;
  /// 显示给用户的文本
  final String label;
  /// 可选的图标
  final IconData? icon;

  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });

  /// 重写相等操作符，基于value值判断两个DropdownItem是否相等
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  /// 重写hashCode，与相等操作符保持一致
  @override
  int get hashCode => value.hashCode;

  /// 重写toString方法，方便调试
  @override
  String toString() => 'DropdownItem(value: $value, label: $label)';
}