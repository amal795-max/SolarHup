import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/widgets/image_widget.dart';

/// Hero image section — cover photo from the API, or gradient fallback.
/// All interactive elements (favorite heart, store badge) live in the card below.
class StoreInfoHeaderSection extends StatelessWidget {
  final StoreInfoData data;

  const StoreInfoHeaderSection({super.key, required this.data});

  bool get _hasCover => _isValidImageUrl(data.coverImageUrl);

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
        if (_hasCover)
          ImageWidget(
            image: data.coverImageUrl,
            fit: BoxFit.cover,
            borderRadius: 0,
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [darker, base],
              ),
            ),
          ),

        if (_hasCover)
          Container(
            color: Colors.black.withValues(alpha: 0.22),
          )
        else
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

        if (!_hasCover)
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

bool _isValidImageUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final uri = Uri.tryParse(url);
  return uri != null && uri.isAbsolute;
}
