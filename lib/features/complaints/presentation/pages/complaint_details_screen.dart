import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';
import 'package:untitled1/features/complaints/presentation/bloc/complaint_cubit.dart';
import '../../../../widgets/animation_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../widget/complaint_status.dart';
import '../widget/complaint_time_line.dart';
import 'conversation_screen.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final int complaintId;

  const ComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    context.read<ComplaintCubit>().getComplaintDetails(widget.complaintId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${'complaint_details'.tr()}  ${widget.complaintId}'.tr(),
            style: AppStyle.h6,
          ),
          bottom: TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 3,
            dividerColor: AppColors.lightGrey,
            tabs: [
              Tab(text: 'details'.tr()),
              Tab(text: 'chat'.tr()),
            ],
          ),
        ),
        body: BlocBuilder<ComplaintCubit, ComplaintState>(
          builder: (context, state) {
            if (state is ComplaintError && state is! ComplaintDetailsSuccess) {
              return errorWidget(
                message: state.message,
                hasButton: true,
                onPressed: _fetchDetails,
              );
            }
            if (state is ComplaintDetailsLoading || state is ComplaintInitial) {
              return TabBarView(
                children: [
                  Skeletonizer(
                    enabled: true,
                    child: _buildDetailsTab(_getFakeComplaint()),
                  ),
                  ComplaintConversationScreen(complaint: _getFakeComplaint()),
                ],
              );
            }

            if (state is ComplaintDetailsSuccess) {
              return TabBarView(
                children: [
                  _buildDetailsTab(state.complaint),
                  ComplaintConversationScreen(complaint: state.complaint),
                ],
              );
            }

            if (state is ComplaintError) {
              return errorWidget(
                message: state.message,
                hasButton: true,
                onPressed: _fetchDetails,
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDetailsTab(ComplaintModel complaint) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimationWidget(child: _buildInfoCard(complaint)),
          SizedBox(height: 24.h),

          AnimationWidget(
            child: Text(
              'status_timeline'.tr(),
              style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 16.h),
          AnimationWidget(child: buildTimeline(complaint,context)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ComplaintModel complaint) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ComplaintStatus(status: complaint.status),
              Text(
                DataHelper.dateFormat('MMM dd, yyyy',complaint.createdAt,locale: context.locale),
                style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            complaint.subject,
            style: AppStyle.h5.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          const Divider(),
          SizedBox(height: 8.h),
          Text(
            'store_name'.tr(),
            style: AppStyle.bodyXSmall.copyWith(color: AppColors.grey),
          ),
          Text(
            complaint.businessName,
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  ComplaintModel _getFakeComplaint() {
    return ComplaintModel(
      id: 0,
      customerId: 0,
      customerPhone: '',
      businessId: 0,
      businessName: 'Loading Store...',
      subject: 'Loading subject...',
      status: 'pending',
      messages: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
