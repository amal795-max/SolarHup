import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TextRichWidget extends StatelessWidget {
  final String label;
  final Color? color;
  final String value;
  final TextStyle ? style;
  final TextStyle ? valueStyle;

  const TextRichWidget({
    required this.label,
    required this.value,
    super.key, this.style, this.color, this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style:style?? TextStyle(fontSize: 14.sp),
        children: [
          TextSpan(text: value, style: valueStyle?.copyWith(color: color),),
        ],
      ),
    );
  }
}