import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onCartTap;

  const HomeAppBar({super.key, this.onMenuTap, this.onCartTap});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDark ? AppColors.darkContainer : AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: isDark ? AppColors.white : AppColors.black,
          size: 24.sp,
        ),
        onPressed: onMenuTap,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt,
            color: AppColors.secondaryColor,
            size: 22.sp,
          ),
          SizedBox(width: 3.w),
          Text(
            'SolarHub',
            style: AppStyle.h6.copyWith(
              color: isDark ? AppColors.white : AppColors.primaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: isDark ? AppColors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: onCartTap,
        ),
      ],
    );
  }
}
