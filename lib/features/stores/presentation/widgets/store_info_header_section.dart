import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

/// Pure hero image section — gradient background with a subtle watermark icon.
/// All interactive elements (Follow button, store badge) live in the card below.
class StoreInfoHeaderSection extends StatelessWidget {
  final StoreInfoData data;

  const StoreInfoHeaderSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final base = Color(data.imagePlaceholderColorValue);
    final darker = Color.fromARGB(
      255,
      (base.r * 0.40).round(),
      (base.g * 0.40).round(),
      (base.b * 0.40).round(),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Gradient background ──────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darker, base],
            ),
          ),
        ),

        // ── Radial light overlay ─────────────────────────────────────────
        Opacity(
          opacity: 0.14,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.55, -0.6),
                radius: 1.2,
                colors: [Colors.white, Colors.transparent],
              ),
            ),
          ),
        ),

        // ── Watermark icon ───────────────────────────────────────────────
        Positioned(
          right: -20.w,
          bottom: -20.h,
          child: Icon(
            Icons.solar_power_rounded,
            size: 200.sp,
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
      ],
    );
  }
}
