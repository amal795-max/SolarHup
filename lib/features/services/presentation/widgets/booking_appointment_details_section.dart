import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final footerColor = isDark
        ? AppColors.darkGray.withValues(alpha: 0.5)
        : AppColors.lightGrey.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withValues(
                      alpha: isDark ? 0.25 : 0.35,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'status_confirmed'.tr(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.tertiaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.grey,
                    ),
                    valueStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                    color: valueColor,
                  ),
                ),
                SizedBox(
                  height: 36.h,
                  child: TextButton.icon(
                    onPressed: isDownloadingReceipt ? null : onReceiptTap,
                    style: TextButton.styleFrom(
                      foregroundColor: valueColor,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    icon: isDownloadingReceipt
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: valueColor,
                            ),
                          )
                        : Icon(Icons.download_outlined, size: 18.sp),
                    label: Text(
                      'btn_receipt'.tr(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                    ),
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
