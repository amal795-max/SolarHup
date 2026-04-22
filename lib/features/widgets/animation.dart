import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WashingAnimation extends StatelessWidget {
  final Widget child; // The widget to animate
  final Duration fadeDuration; // Fade-in duration
  final Duration slideDuration; // Slide duration
  final Duration scaleDuration; // Scale duration
  final Curve curve; // Base curve for smooth motion
  final bool withSpin; // Add washing machine spin
  final bool withShimmer; // Add cleaning shimmer

  const WashingAnimation({
    required this.child,
    this.fadeDuration = const Duration(milliseconds: 600), // Slower fade
    this.slideDuration = const Duration(milliseconds: 200), // Slower slide
    this.scaleDuration = const Duration(milliseconds: 1000), // Slower scale
    this.curve = Curves.easeInOutSine, // Softer, wave-like curve
    this.withSpin = false,
    this.withShimmer = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var animation = child
        .animate()
        // Fade in slowly, like water filling up
        .fade(duration: fadeDuration, curve: curve)
        // Slide down with a gentle sway, like clothes dropping into a wash
        .slideY(
          begin: 0.9, // Higher start for more motion
          end: 0.0,
          duration: slideDuration,
          curve: curve,
        )
        .moveX(
          begin: -15.0,
          // Subtle left-right sway
          end: 0.0,
          duration: slideDuration ~/ 2,
          curve: Curves.easeInOut,
          delay: fadeDuration ~/ 2, // Mid-animation sway
        )
        // Scale up smoothly with a ripple effect
        .scale(
          begin: Offset(0.8, 0.8),
          // Smaller start for dramatic growth
          end: Offset(1, 1),
          duration: scaleDuration,
          delay: 300.ms,
          // Slightly later for sequencing
          curve: Curves.easeOutBack, // Overshoots slightly for bounce
        );

    // Add washing machine spin (slow and rhythmic)
    if (withSpin) {
      animation = animation.then().rotate(
        begin: 0.0,
        end: 1.0, // Full slow spin
        duration: 1200.ms, // Slower for a washing cycle feel
        curve: Curves.easeInOut,
      );
    }

    // Add cleaning shimmer (dreamy and prolonged)
    if (withShimmer) {
      animation = animation.then().shimmer(
        color: Colors.blueAccent.withValues(alpha: 0.3), // Watery sparkle
        duration: 1500.ms, // Extended shimmer
        delay: 500.ms,
        size: 0.3, // Larger shimmer area
      );
    }

    return animation;
  }
}
