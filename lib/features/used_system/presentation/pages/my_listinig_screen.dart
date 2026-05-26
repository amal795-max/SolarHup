import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderSection(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: 4,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final listings = [
                    const _ListingData(
                      title: '5kW Hybrid System',
                      subtitle: 'Huawei Inverter + 10 Jinko Panels',
                      price: r'$4,250',
                      status: 'active',
                      imagePath: 'assets/images/solar_system_1.png',
                    ),
                    const _ListingData(
                      title: '10kWh Lithium Battery',
                      subtitle: 'Wall-mounted, 3000 cycles',
                      price: r'$2,800',
                      status: 'sold',
                      imagePath: 'assets/images/battery_1.png',
                    ),
                    const _ListingData(
                      title: 'Growatt 3kW Inverter',
                      subtitle: 'Single phase, WIFI enabled',
                      price: r'\$890',
                      status: 'active',
                      imagePath: 'assets/images/inverter_1.png',
                    ),
                    const _ListingData(
                      title: 'Growatt 3kW Inverter',
                      subtitle: 'Single phase, WIFI enabled',
                      price: r'$890',
                      status: 'draft',
                      imagePath: 'assets/images/inverter_1.png',
                    ),
                  ];
                  return _ListingCard(data: listings[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingData {
  final String title;
  final String subtitle;
  final String price;
  final String status;
  final String imagePath;

  const _ListingData({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.status,
    required this.imagePath,
  });
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Text(
            'my_listings'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'manage_listings_subtitle'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final _ListingData data;

  const _ListingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: AppColors.backGroundGrey,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.inventory_2_outlined, size: 40.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _StatusBadge(status: data.status),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        data.subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        data.price,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _ActionButtons(status: data.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;
    String label = status;

    switch (status) {
      case 'active':
        bgColor = AppColors.secondaryColor;
        textColor = Colors.black87;
        label = 'active'.tr();
        break;
      case 'sold':
        bgColor = Colors.grey;
        label = 'sold'.tr();
        break;
      case 'draft':
        bgColor = AppColors.primaryColor;
        label = 'draft'.tr();
        break;
      default:
        bgColor = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String status;

  const _ActionButtons({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 'sold') {
      return Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Expanded(
              child:CustomButton(
                type: ButtonType.outlined,
                text:'view_history'.tr(),
                height: 40,
                onPressed: () {},
                icon: Icons.history,
                borderColor: AppColors.grey,
                textColor: AppColors.grey,
              ),
            ),
            SizedBox(width: 8.w),
            _DeleteButton(onPressed: () {}),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              text: 'edit'.tr(),
              height: 40,
              onPressed: () {},
              icon:  Icons.mode_edit_outline_outlined,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 3,
            child: CustomButton(
              text: 'mark_as_sold'.tr(),
              height: 40,
              onPressed: () {},
              icon:  Icons.check_circle_outline,
              type: ButtonType.outlined,
            ),


          ),
          SizedBox(width: 8.w),
          _DeleteButton(onPressed: () {}),
        ],
      ),
    );
  }
}


class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.delete_outline, color: AppColors.red, size: 20.sp),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
