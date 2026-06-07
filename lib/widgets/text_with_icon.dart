import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/theme/app_style.dart';
import '../core/theme/app_colors.dart';

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    super.key,
     this.onTap,
     this.hasSvg=false,
    required this.title,
    this.underLine = false,
     this.svgPath,

     this.color=AppColors.primaryColor ,
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
                    AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ):Icon(icon,size: 16.r,color: AppColors.primaryColor,),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.labelSmall.copyWith(
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
