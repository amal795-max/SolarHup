import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "../../core/constants/app_colors.dart";
import "../../core/constants/asset_path.dart";

class Loader extends StatelessWidget {
  const Loader({super.key, this.color, this.radius});

  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(ImagesPaths.appLogo, height: 100.w, width: 100.w),
    );
  }
}

class ImageLoader extends StatelessWidget {
  const ImageLoader({super.key, this.color, this.radius});

  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.mainAppColor,

      ),
    );
  }
}
