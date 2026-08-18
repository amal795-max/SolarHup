import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class CompareVsCelebration extends StatefulWidget {
  final VoidCallback onFinished;

  const CompareVsCelebration({
    super.key,
    required this.onFinished,
  });

  @override
  State<CompareVsCelebration> createState() => _CompareVsCelebrationState();
}

class _CompareVsCelebrationState extends State<CompareVsCelebration> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 88.w,
          height: 88.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondaryColor,
                AppColors.secondaryColor.withValues(alpha: 0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryColor.withValues(alpha: 0.45),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'VS',
            style: AppStyle.h4.copyWith(
              color: AppColors.brown,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 180.ms)
            .scale(
              begin: const Offset(0.35, 0.35),
              end: const Offset(1, 1),
              duration: 650.ms,
              curve: Curves.elasticOut,
            )
            .then(delay: 500.ms)
            .fadeOut(duration: 250.ms),
      ),
    );
  }
}
