import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/image_widget.dart';

class BlogArticleImage extends StatelessWidget {
  final String? imageUrl;
  final int placeholderColorValue;
  final double? height;
  final double? width;
  final BoxFit fit;
  final IconData placeholderIcon;
  final List<Widget>? overlays;

  const BlogArticleImage({
    super.key,
    required this.imageUrl,
    required this.placeholderColorValue,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.article_outlined,
    this.overlays,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_hasImage)
            ImageWidget(
              image: imageUrl,
              fit: fit,
              borderRadius: 0,
            )
          else
            ColoredBox(
              color: Color(placeholderColorValue),
              child: Center(
                child: Icon(
                  placeholderIcon,
                  size: 42.sp,
                  color: AppColors.grey.withValues(alpha: 0.55),
                ),
              ),
            ),
          if (overlays != null) ...overlays!,
        ],
      ),
    );
  }
}
