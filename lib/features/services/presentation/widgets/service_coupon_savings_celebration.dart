import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class ServiceCouponSavingsCelebration extends StatefulWidget {
  final double savingsAmount;
  final VoidCallback onRemove;
  final int animationSeed;

  const ServiceCouponSavingsCelebration({
    super.key,
    required this.savingsAmount,
    required this.onRemove,
    required this.animationSeed,
  });

  @override
  State<ServiceCouponSavingsCelebration> createState() =>
      _ServiceCouponSavingsCelebrationState();
}

class _ServiceCouponSavingsCelebrationState
    extends State<ServiceCouponSavingsCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    HapticFeedback.mediumImpact();
  }

  @override
  void didUpdateWidget(covariant ServiceCouponSavingsCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationSeed != widget.animationSeed) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedAmount = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 2,
    ).format(widget.savingsAmount);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ..._buildSparkles(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 18.h, 12.w, 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.secondaryColor.withValues(alpha: 0.35),
                AppColors.lightYellow.withValues(alpha: 0.95),
                AppColors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.secondaryColor.withValues(alpha: 0.65),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryColor.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PulsingBadge(
                    controller: _sparkleController,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'service_coupon_celebration_title'.tr(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.tertiaryColor,
                            letterSpacing: 0.3,
                          ),
                        )
                            .animate(key: ValueKey(widget.animationSeed))
                            .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                            .slideX(
                              begin: -0.15,
                              end: 0,
                              duration: 450.ms,
                              curve: Curves.easeOutBack,
                            ),
                        SizedBox(height: 6.h),
                        Text(
                          'service_coupon_applied'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.deepGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                            .animate(key: ValueKey('code-${widget.animationSeed}'))
                            .fadeIn(delay: 120.ms, duration: 350.ms),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onRemove,
                    child: Text('remove_coupon'.tr()),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Center(
                child: Column(
                  children: [
                    Text(
                      formattedAmount,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryColor,
                        height: 1,
                        shadows: [
                          Shadow(
                            color: AppColors.secondaryColor.withValues(
                              alpha: 0.45,
                            ),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    )
                        .animate(key: ValueKey('amt-${widget.animationSeed}'))
                        .fadeIn(delay: 260.ms, duration: 400.ms)
                        .scale(
                          begin: const Offset(0.4, 0.4),
                          end: const Offset(1, 1),
                          delay: 260.ms,
                          duration: 650.ms,
                          curve: Curves.elasticOut,
                        )
                        .shimmer(
                          delay: 900.ms,
                          duration: 1200.ms,
                          color: AppColors.white.withValues(alpha: 0.55),
                        ),
                    SizedBox(height: 6.h),
                    Text(
                      'service_coupon_saved'.tr(args: [formattedAmount]),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.tertiaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                        .animate(key: ValueKey('sub-${widget.animationSeed}'))
                        .fadeIn(delay: 400.ms, duration: 300.ms)
                        .slideY(begin: 0.15, end: 0, delay: 400.ms),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate(key: ValueKey('card-${widget.animationSeed}'))
            .fadeIn(duration: 280.ms)
            .scale(
              begin: const Offset(0.92, 0.92),
              end: const Offset(1, 1),
              duration: 520.ms,
              curve: Curves.easeOutBack,
            ),
      ],
    );
  }

  List<Widget> _buildSparkles() {
    const sparkleSpecs = [
      _SparkleSpec(top: -6, left: 18, delayMs: 0, icon: Icons.star_rounded),
      _SparkleSpec(top: 8, right: 12, delayMs: 120, icon: Icons.auto_awesome),
      _SparkleSpec(bottom: 10, left: 28, delayMs: 220, icon: Icons.star_rounded),
      _SparkleSpec(top: -2, right: 48, delayMs: 80, icon: Icons.savings_rounded),
      _SparkleSpec(bottom: -4, right: 24, delayMs: 180, icon: Icons.auto_awesome),
    ];

    return sparkleSpecs.map((spec) {
      Widget sparkle = Icon(
        spec.icon,
        size: spec.icon == Icons.savings_rounded ? 16.sp : 14.sp,
        color: AppColors.secondaryColor.withValues(alpha: 0.85),
      );

      sparkle = sparkle
          .animate(
            key: ValueKey('${spec.icon}-${widget.animationSeed}-${spec.delayMs}'),
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fadeIn(delay: spec.delayMs.ms, duration: 350.ms)
          .scale(
            begin: const Offset(0.2, 0.2),
            end: const Offset(1, 1),
            delay: spec.delayMs.ms,
            duration: 500.ms,
            curve: Curves.easeOutBack,
          )
          .then(delay: 200.ms)
          .moveY(begin: 0, end: -6, duration: 1400.ms, curve: Curves.easeInOut)
          .fadeOut(delay: 1100.ms, duration: 400.ms);

      return Positioned(
        top: spec.top?.h,
        left: spec.left?.w,
        right: spec.right?.w,
        bottom: spec.bottom?.h,
        child: sparkle,
      );
    }).toList();
  }
}

class _PulsingBadge extends StatelessWidget {
  final AnimationController controller;

  const _PulsingBadge({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pulse = 1 + math.sin(controller.value * math.pi * 2) * 0.06;
        return Transform.scale(
          scale: pulse,
          child: child,
        );
      },
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryColor,
              Color(0xFFFFE566),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor.withValues(alpha: 0.45),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.celebration_rounded,
          color: AppColors.primaryColor,
          size: 24.sp,
        ),
      ),
    );
  }
}

class _SparkleSpec {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final int delayMs;
  final IconData icon;

  const _SparkleSpec({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.delayMs,
    required this.icon,
  });
}
