import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "../../core/constants/app_colors.dart";
import "loader.dart";

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, this.image, this.height, this.width, this.fit});

  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (image == null ||
        image!.isEmpty ||
        !Uri.tryParse(image!)!.hasAbsolutePath) {
      return Icon(Icons.broken_image, size: 25.w,color: AppColors.grey,);
    }
    return Center(
      child: InteractiveViewer(

        child: CachedNetworkImage(
          imageUrl: image!,
          height: height ?? 80.h,
          width: width ?? 110.w,
          fit: fit ?? BoxFit.cover,
          placeholder:
              (BuildContext context, String url) =>
                  ImageLoader(radius: 40.r, color: AppColors.mainAppColor),
          errorWidget:
              (BuildContext context, String url, error) =>
                  Icon(Icons.error, size: 25.w),
        ),
      ),
    );
  }
}
