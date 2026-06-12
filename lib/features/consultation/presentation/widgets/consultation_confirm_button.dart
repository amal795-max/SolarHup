import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ConsultationConfirmButton extends StatelessWidget {
  const ConsultationConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: CustomButton(
        text: 'consultation_confirm_btn'.tr(),
        icon: Icons.event_available_outlined,
        iconLeft: false,
        backgroundColor: AppColors.primaryColor,
        textColor: AppColors.white,
        fontWeight: FontWeight.w700,
        height: 52.h,
        onPressed: () => context
            .read<BookConsultationBloc>()
            .add(const ConfirmBookingEvent()),
      ),
    );
  }
}
