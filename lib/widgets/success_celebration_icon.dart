import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class SuccessCelebrationIcon extends StatefulWidget {
  final double size;
  final IconData icon;
  final Color? iconColor;
  final Color? ringColor;

  const SuccessCelebrationIcon({
    super.key,
    this.size = 120,
    this.icon = Icons.check_circle_rounded,
    this.iconColor,
    this.ringColor,
  });

  @override
  State<SuccessCelebrationIcon> createState() => _SuccessCelebrationIconState();
}

class _SuccessCelebrationIconState extends State<SuccessCelebrationIcon> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final ring = widget.ringColor ?? AppColors.secondaryColor;
    final iconColor = widget.iconColor ?? AppColors.primaryColor;

    return Container(
      width: widget.size.w,
      height: widget.size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ring.withValues(alpha: 0.18),
        boxShadow: [
          BoxShadow(
            color: ring.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          widget.icon,
          color: iconColor,
          size: (widget.size * 0.62).sp,
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.55, 0.55),
          end: const Offset(1, 1),
          duration: 650.ms,
          curve: Curves.elasticOut,
        )
        .then(delay: 150.ms)
        .shimmer(
          duration: 1400.ms,
          color: AppColors.white.withValues(alpha: 0.35),
        );
  }
}
