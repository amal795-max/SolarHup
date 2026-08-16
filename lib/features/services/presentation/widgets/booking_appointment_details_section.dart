import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/orders/presentation/widgets/staus_order_service.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';
import 'package:untitled1/features/services/presentation/widgets/appointment_detail_row.dart';
import 'package:untitled1/widgets/text_rich_widget.dart';

class BookingAppointmentDetailsSection extends StatelessWidget {
  final BookingConfirmationModel booking;
  final bool isDownloadingReceipt;
  final VoidCallback? onReceiptTap;

  const BookingAppointmentDetailsSection({
    super.key,
    required this.booking,
    this.isDownloadingReceipt = false,
    this.onReceiptTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final valueColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final footerColor = isDark
        ? AppColors.darkGray.withValues(alpha: 0.5)
        : AppColors.lightGrey.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!context.brightness)
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'appointment_details_header'.tr(),
                    style:AppStyle.labelSmall.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                StatusOrderService(text: booking.statusEnum.status.tr(), color: booking.statusEnum),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                AppointmentDetailRow(
                  icon: Icons.solar_power_outlined,
                  label: 'label_service_type'.tr(),
                  value: booking.serviceType,
                  valueColor: valueColor,
                ),
                SizedBox(height: 12.h),
                AppointmentDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'label_date_time'.tr(),
                  value: booking.dateTimeLabel,
                  valueColor: valueColor,
                ),
                SizedBox(height: 12.h),
                AppointmentDetailRow(
                  label: 'label_lead_technician'.tr(),
                  value: booking.technician.name,
                  valueColor: valueColor,
                  leading: _TechnicianAvatar(technician: booking.technician),
                ),
                SizedBox(height: 12.h),
                AppointmentDetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'label_address'.tr(),
                  value: booking.address,
                  valueColor: valueColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: footerColor,
            child: Row(
              children: [
                Expanded(
                  child: TextRichWidget(
                    label: 'label_booking_id'.tr(),
                    value: booking.bookingId,
                    style: AppStyle.labelSmall.copyWith(
                      color: AppColors.grey,
                    ),
                    valueStyle: AppStyle.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                    color: valueColor,
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

class _TechnicianAvatar extends StatelessWidget {
  final BookingTechnicianModel technician;

  const _TechnicianAvatar({required this.technician});

  @override
  Widget build(BuildContext context) {
    final initials = technician.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Color(technician.avatarColorValue),
      backgroundImage:
          technician.avatarUrl != null ? NetworkImage(technician.avatarUrl!) : null,
      child: technician.avatarUrl == null
          ? Text(
              initials,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            )
          : null,
    );
  }
}
