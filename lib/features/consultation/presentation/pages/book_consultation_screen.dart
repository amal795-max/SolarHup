import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/consultation/data/data_source/consultation_remote_data_source.dart';
import 'package:untitled1/features/consultation/data/repositories/consultation_repository.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';
import 'package:untitled1/features/consultation/presentation/widgets/book_consultation_app_bar.dart';
import 'package:untitled1/features/consultation/presentation/widgets/consultation_attachments_section.dart';
import 'package:untitled1/features/consultation/presentation/widgets/consultation_confirm_button.dart';
import 'package:untitled1/features/consultation/presentation/widgets/consultation_date_time_section.dart';
import 'package:untitled1/features/consultation/presentation/widgets/consultation_details_section.dart';
import 'package:untitled1/features/consultation/presentation/widgets/consultation_expert_section.dart';
import 'package:untitled1/features/consultation/presentation/widgets/consultation_type_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BookConsultationScreen extends StatelessWidget {
  const BookConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookConsultationBloc(
        ConsultationRepositoryImpl(
          remote: const ConsultationRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadBookConsultationEvent()),
      child: const _BookConsultationView(),
    );
  }
}

class _BookConsultationView extends StatelessWidget {
  const _BookConsultationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<BookConsultationBloc, BookConsultationState>(
        builder: (context, state) {
          return switch (state) {
            BookConsultationLoading() => const LoadingWidget(),
            BookConsultationError(:final message) => SafeArea(
              child: EmptyWidget(
                icon: Icons.error_outline_rounded,
                iconSize: 48,
                iconColor: AppColors.red,
                title: 'stores_error_title'.tr(),
                subtitle: message,
                action: CustomButton(
                  text: 'stores_retry'.tr(),
                  onPressed: () => context.read<BookConsultationBloc>().add(
                    const LoadBookConsultationEvent(),
                  ),
                  width: 160.w,
                ),
              ),
            ),
            BookConsultationLoaded() => SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BookConsultationAppBar(),
                    SizedBox(height: 8.h),
                    ConsultationExpertSection(
                      experts: state.data.experts,
                      selectedExpertId: state.selectedExpertId,
                    ),
                    SizedBox(height: 24.h),
                    ConsultationTypeSection(
                      types: state.data.types,
                      selectedTypeId: state.selectedTypeId,
                    ),
                    SizedBox(height: 24.h),
                    ConsultationDateTimeSection(
                      monthYearLabel: state.data.monthYearLabel,
                      calendarDays: state.data.calendarDays,
                      timeSlots: state.data.timeSlots,
                      selectedDate: state.selectedDate,
                      selectedTimeSlotId: state.selectedTimeSlotId,
                    ),
                    SizedBox(height: 24.h),
                    ConsultationDetailsSection(
                      fullName: state.fullName,
                      phone: state.phone,
                      address: state.address,
                      notes: state.notes,
                    ),
                    SizedBox(height: 8.h),
                    ConsultationAttachmentsSection(
                      attachments: state.attachments,
                    ),
                    const ConsultationConfirmButton(),
                  ],
                ),
              ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
