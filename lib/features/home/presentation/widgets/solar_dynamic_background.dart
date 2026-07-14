import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// Premium, animated solar background for the Home page.
///
/// - Gradient adapts to light / dark themes.
/// - Floating solar icons drift slowly using [flutter_animate].
/// - Soft energy-wave lines are drawn by a lightweight [CustomPainter].
/// - The [child] scrolls above the background while the visual effects stay
///   fixed to the viewport.
class SolarDynamicBackground extends StatelessWidget {
  final Widget child;

  const SolarDynamicBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Base gradient ─────────────────────────────────────────────────
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark ? _darkGradient : _lightGradient,
            ),
          ),
        ),

        // ── Ambient glow orbs (very cheap, no blur) ───────────────────────
        Positioned(
          top: -60.h,
          right: -40.w,
          child: _AmbientOrb(
            size: 260.r,
            colors: isDark
                ? [AppColors.primaryColor, AppColors.secondaryColor]
                : [AppColors.secondaryColor, AppColors.lightYellow],
          ),
        ),

        // ── Moving energy-wave lines ──────────────────────────────────────
        const Positioned.fill(
          child: RepaintBoundary(
            child: _EnergyWavesLayer(),
          ),
        ),

        // ── Floating solar icons ──────────────────────────────────────────
        ..._floatingIcons(isDark),

        // ── Content ───────────────────────────────────────────────────────
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }

  static const Gradient _lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF9EA),
      AppColors.backGroundGrey,
      AppColors.white,
    ],
    stops: [0.0, 0.45, 1.0],
  );

  static const Gradient _darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.deepPrimaryColor,
      AppColors.darkMode,
      AppColors.black,
    ],
    stops: [0.0, 0.55, 1.0],
  );

  List<Widget> _floatingIcons(bool isDark) {
    final color = (isDark ? AppColors.white : AppColors.primaryColor)
        .withValues(alpha: isDark ? 0.06 : 0.05);

    final items = [
      _FloatingIcon(
        top: 0.08,
        left: 0.68,
        icon: Icons.wb_sunny_rounded,
        size: 90.r,
        color: color,
        duration: const Duration(seconds: 6),
        delay: const Duration(milliseconds: 0),
      ),
      _FloatingIcon(
        top: 0.42,
        right: 0.5,
        icon: Icons.solar_power_rounded,
        size: 70.r,
        color: color,
        duration: const Duration(seconds: 7),
        delay: const Duration(milliseconds: 400),
      ),
      _FloatingIcon(
        top: 0.55,
        left: 0.04,
        icon: Icons.bolt_rounded,
        size: 80.r,
        color: color,
        duration: const Duration(seconds: 5),
        delay: const Duration(milliseconds: 800),
      ),
      _FloatingIcon(
        top: 0.78,
        right: 0.12,
        icon: Icons.energy_savings_leaf_rounded,
        size: 65.r,
        color: color,
        duration: const Duration(seconds: 8),
        delay: const Duration(milliseconds: 1200),
      ),
    ];

    return items.map((e) => Positioned(
      top: e.top! * 1.sh,
      left: e.left != null ? e.left! * 1.sw : null,
      right: e.right != null ? e.right! * 1.sw : null,
      child: e,
    )).toList();
  }
}

// ── Ambient orb ────────────────────────────────────────────────────────────

class _AmbientOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _AmbientOrb({required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors[0].withValues(alpha: 0.28),
            colors[1].withValues(alpha: 0.05),
            colors[1].withValues(alpha: 0),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
    // Slow radial pulse.
    // .animate(onComplete: (c) => c.repeat(reverse: true))
    // .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 8.seconds);
  }
}

// ── Floating icon ──────────────────────────────────────────────────────────

class _FloatingIcon extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final IconData icon;
  final double size;
  final Color color;
  final Duration duration;
  final Duration delay;

  const _FloatingIcon({
    this.top,
    this.left,
    this.right,
    required this.icon,
    required this.size,
    required this.color,
    required this.duration,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color)
        .animate()
        .then(delay: delay)
        .custom(
          duration: duration,
          builder: (context, value, child) {
            final y = sin(value * 2 * pi) * 12;
            final rotation = cos(value * 2 * pi) * 0.08;
            return Transform.translate(
              offset: Offset(0, y),
              child: Transform.rotate(
                angle: rotation,
                child: child,
              ),
            );
          },
        )
        .animate(onComplete: (controller) => controller.repeat());
  }
}

// ── Energy waves layer ───────────────────────────────────────────────────────

class _EnergyWavesLayer extends StatefulWidget {
  const _EnergyWavesLayer();

  @override
  State<_EnergyWavesLayer> createState() => _EnergyWavesLayerState();
}

class _EnergyWavesLayerState extends State<_EnergyWavesLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _EnergyWavesPainter(
            progress: _controller.value,
            lineColor: (isDark ? AppColors.white : AppColors.primaryColor)
                .withValues(alpha: isDark ? 0.04 : 0.035),
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _EnergyWavesPainter extends CustomPainter {
  final double progress;
  final Color lineColor;

  _EnergyWavesPainter({required this.progress, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const waveCount = 4;
    final verticalStep = size.height / (waveCount + 1);

    for (int i = 1; i <= waveCount; i++) {
      final y = verticalStep * i;
      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += 8) {
        final normalizedX = x / size.width;
        final amplitude = 8 + (i * 4);
        final frequency = 2 + i;
        final phase = progress * 2 * pi + (i * pi / 3);
        final dy = sin(normalizedX * frequency * pi * 2 + phase) * amplitude;
        path.lineTo(x, y + dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyWavesPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.lineColor != lineColor;
  }
}
