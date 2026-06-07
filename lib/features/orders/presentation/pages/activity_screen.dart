import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';
import 'package:untitled1/widgets/text_with_icon.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('activity_title'.tr())),
      body: Column(
        children: [
          _TabSwitcher(
            selectedIndex: _selectedTab,
            onTabChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          Expanded(
            child: _selectedTab == 0 ? _buildOrdersTab() : _buildServicesTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        spacing: 16.h,
        children: const [
          _OrderCard(
            orderId: '#SH-9821-XP',
            productName: 'Smart Inverter Pro',
            price: r'$1,249.00',
            statusKey: 'status_processing',
            statusColor: AppColors.brown,
            icon: Icons.computer,
          ),
          _OrderCard(
            orderId: '#SH-7742-LO',
            productName: 'Solar Panel Mounts (x8)',
            price: r'$450.00',
            statusKey: 'status_shipped',
            statusColor: Colors.blue,
            icon: Icons.local_shipping,
          ),
          _TrackDeliveryBanner(),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        spacing: 16.h,
        children: const [
          _ServiceCard(
            month: 'OCT',
            day: '12',
            title: 'System Maintenance',
            techName: 'Sarah Johnson',
            time: '09:30 AM - 11:00 AM',
            isUpcoming: true,
          ),
          _ServiceCard(
            month: 'SEP',
            day: '28',
            title: 'Battery Installation',
            techName: 'Mike Rivera',
            time: 'Completed Successfully',
            isUpcoming: false,
          ),
        ],
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _TabSwitcher({required this.selectedIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: context.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              child: _TabItem(
                title: 'orders_tab'.tr(),
                isActive: selectedIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              child: _TabItem(
                title: 'services_tab'.tr(),
                isActive: selectedIndex == 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: isActive ? context.colorScheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          title,
          style: AppStyle.labelMedium.copyWith(
            color: isActive ? context.colorScheme.onSurface : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String productName;
  final String price;
  final String statusKey;
  final Color statusColor;
  final IconData icon;

  const _OrderCard({
    required this.orderId,
    required this.productName,
    required this.price,
    required this.statusKey,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
              ),
              _StatusBadge(text: statusKey.tr(), color: statusColor),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Order $orderId',
            style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
          ),
          Text(
            productName,
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(color: AppColors.borderColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_price_label'.tr(),
                style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
              ),
              Text(
                price,
                style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TrackDeliveryBanner extends StatelessWidget {
  const _TrackDeliveryBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF536A7D),
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1558449028-b53a39d100fc?w=500&q=80',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'track_delivery_title'.tr(),
            style: AppStyle.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'track_delivery_desc'.tr(),
            style: AppStyle.labelSmall.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map_outlined, size: 18),
            label: Text('open_map_btn'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: AppColors.primaryColor,
              minimumSize: Size(120.w, 40.h),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String month;
  final String day;
  final String title;
  final String techName;
  final String time;
  final bool isUpcoming;

  const _ServiceCard({
    required this.month,
    required this.day,
    required this.title,
    required this.techName,
    required this.time,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return container(
      context: context,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  month,
                  style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
                ),
                Text(
                  day,
                  style: AppStyle.h4.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isUpcoming)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.amber,
                        size: 16,
                      )
                    else
                      _StatusBadge(
                        text: 'status_past'.tr(),
                        color: Colors.grey,
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                TextWithIcon(
                  title: '${'tech_label'.tr()} $techName',
                  icon: Icons.person_outline,
                  color: AppColors.grey,
                ),
                TextWithIcon(
                  title: time,
                  icon: Icons.access_time,
                  color: AppColors.grey,
                ),

                SizedBox(height: 12.h),
                if (isUpcoming)
                  Row(
                    spacing: 12.w,
                    children: [
                      Expanded(
                        child: CustomButton(text: 'reschedule_btn'.tr()),
                      ),
                      Expanded(
                        child: CustomButton(
                          text: 'details_btn'.tr(),
                          type: ButtonType.outlined,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'download_report_btn'.tr(),
                      type: ButtonType.outlined,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
