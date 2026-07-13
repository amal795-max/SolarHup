import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onCartTap;

  const HomeAppBar({super.key, this.onMenuTap, this.onCartTap});

  @override
  Size get preferredSize => Size.fromHeight(75.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        CircleAvatar(
          backgroundColor: AppColors.lightGrey,
          child: IconButton(
            icon:  Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primaryColor,
              size: 20.r,
            ),
            onPressed: onCartTap,
          ),
        ),

        SizedBox(width: 8.w,),
        CircleAvatar(
          backgroundColor: AppColors.lightGrey,
          child: IconButton(
            icon:  Icon(
              Icons.notifications_none,
              color: AppColors.primaryColor,
              size: 22.r,
            ),
            onPressed: onMenuTap,
          ),
        ),
        SizedBox(width: 16.w,),
      ],
        title: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text('welcome_to'.tr(), style: AppStyle.bodyMedium),
                    Text('topsolar'.tr(), style: AppStyle.h4),
                  ],
                ),

              ],
            ),
          ],
        ),
    );
  }
}
