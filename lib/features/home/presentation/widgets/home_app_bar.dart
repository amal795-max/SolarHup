import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import '../../../../core/helper/extensions.dart';

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
          backgroundColor:AppColors.lightGrey,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.blue,
              size: 22,
            ),
            onPressed: onCartTap,
          ),
        ),
        SizedBox(width: 8.w,),
        CircleAvatar(
          backgroundColor:AppColors.lightGrey,
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.blue,
              size: 24,
            ),
            onPressed: onCartTap,
          ),
        ),
        SizedBox(width: 16.w,),
      ],
        title: Column(
          children: [
            Row(
              children: [
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                     Text('welcome_to'.tr(), style: context.textTheme.labelMedium),
                    Text('topsolar'.tr(), style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),

              ],
            ),
          ],
        ),
    );
  }
}
