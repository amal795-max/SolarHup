import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.radius});

  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColor,

      ),
    );
  }
}
