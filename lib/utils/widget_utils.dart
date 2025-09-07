import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class WidgetUtils {
  static WidgetUtils? _instance;

  static WidgetUtils instance() {
    _instance ??= WidgetUtils._();
    return _instance!;
  }

  WidgetUtils._() {}

  ///base64图片加载
  static Widget base64ImageWidget({
    String baseUrl = '',
    BoxFit? fit = BoxFit.cover,
  }) {
    return Image.memory(
      base64Decode(
        baseUrl
            .replaceAll('data:image/png;base64,', '')
            .replaceAll('data:image/jpeg;base64,', '')
            .replaceAll('data:image/gif;base64,', ''),
      ),

      ///防止重绘
      gaplessPlayback: true,
      fit: fit,
    );
  }

  // Widget buildNoElevatedButton(
  //     String text,
  //     double width,
  //     double height, {
  //       Color? bg,
  //       Color textColor = Colors.white,
  //       double textSize = 14,
  //       bool showBorder = false,
  //       VoidCallback? onPressed,
  //     }) {
  //   return HapticInkWell(
  //     onTap: onPressed,
  //     child: Container(
  //       width: width,
  //       height: height,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         color: bg,
  //         borderRadius: BorderRadius.all(Radius.circular(6)),
  //         border:
  //         showBorder == true
  //             ? Border.all(color: Colors.grey, width: 1)
  //             : Border.all(color: Colors.transparent),
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: textSize.sp,
  //           color: textColor,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildElevatedButton(
      String text,
      double width,
      double height, {
        Color? bg,
        Color textColor = Colors.white,
        double textSize = 14,
        VoidCallback? onPressed,
      }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        backgroundColor: bg,
        minimumSize: Size(width, height),
        maximumSize: Size(width, height),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize.sp,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildOutlineButton(
      String text,
      double width,
      double height,
      Color lineColor, {
        Color? bg,
        Color textColor = Colors.white,
        double textSize = 14,
        VoidCallback? onPressed,
      }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        side: BorderSide(color: lineColor, width: 1.r),
        backgroundColor: bg,
        minimumSize: Size(width, height),
        maximumSize: Size(width, height),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize.sp,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(bool select) {
    if (select) {
      return BoxDecoration(
        // 右上 右下圆角
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(2.w),
          bottomRight: Radius.circular(2.w),
        ),
        color: const Color(0xff179CFF),
      );
    } else {
      return BoxDecoration(
        // 右上 右下圆角
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(2.w),
          bottomRight: Radius.circular(2.w),
        ),
        color: const Color(0xff179CFF),
      );
    }
  }
}

class ToolTipWidget extends StatelessWidget {
  const ToolTipWidget({
    super.key,
    required this.message,
    required this.child,
    this.fonSize = 12,
    this.circular = 20,
  });

  final String message;
  final Widget child;
  final double fonSize;
  final double circular;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.longPress,
      preferBelow: false,
      verticalOffset: 0,
      message: message,
      textStyle: TextStyle(color: Colors.red, fontSize: fonSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circular),
        color: const Color.fromRGBO(163, 163, 163, 0.8),
      ),
      waitDuration: const Duration(seconds: 1),
      child: child,
    );
  }
}

class homeTipWidget extends StatelessWidget {
  const homeTipWidget({
    super.key,
    required this.message,
    required this.child,
    this.fonSize = 12,
    this.circular = 20,
  });

  final String message;
  final Widget child;
  final double fonSize;
  final double circular;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      preferBelow: false,
      verticalOffset: 0,
      message: message,
      textStyle: TextStyle(color: Colors.red, fontSize: fonSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circular),
        color: const Color.fromRGBO(163, 163, 163, 0.8),
      ),
      waitDuration: const Duration(seconds: 1),
      child: child,
    );
  }
}
