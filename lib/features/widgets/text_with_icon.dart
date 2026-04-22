import "package:flutter/cupertino.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../core/constants/app_colors.dart";
import "../../core/constants/app_style.dart";

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    super.key,
     this.onTap,
     this.hasSvg=false,
    required this.title,
    this.underLine = false,
     this.svgPath,

     this.color=AppColors.mainAppColor ,
    this.space,
    this.icon,
  });

  final dynamic Function()? onTap;
  final String title;
  final String? svgPath;
  final IconData? icon;
  final Color ?color;
  final bool underLine;
  final bool hasSvg;
  final double? space;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: false,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
         spacing: 8,
          children: [
           hasSvg? SvgPicture.asset(
                svgPath??'',
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.mainAppColor,
                  BlendMode.srcIn,
                ),
              ):Icon(icon,size: 20.r,color: AppColors.mainAppColor,),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.underLineStyle.copyWith(
                color: color,
                decoration:
                    underLine ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
