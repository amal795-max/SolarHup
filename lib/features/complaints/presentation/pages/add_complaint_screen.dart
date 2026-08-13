import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/complaints/presentation/bloc/complaint_cubit.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';

class AddComplaintScreen extends StatefulWidget {
  final int? businessId;

  const AddComplaintScreen({
    super.key,
    this.businessId,
  });

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  late int? _selectedBusinessId;

  @override
  void initState() {
    super.initState();
    _selectedBusinessId = widget.businessId;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create_complaint'.tr()),
      ),
      body: BlocListener<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintActionSuccess) {
            DataHelper.showSnackBar(context: context, message: state.message.tr());
            context.pop();
            context.read<ComplaintCubit>().getMyComplaints();
          } else if (state is ComplaintError) {
            DataHelper.showSnackBar(context: context, message: state.message,);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'complaint_info_title'.tr(),
                  style: AppStyle.h6.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  'complaint_info_subtitle'.tr(),
                  style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
                ),
                SizedBox(height: 24.h),

                CustomTextField(
                  title: 'subject'.tr(),
                  hint: 'complaint_subject_hint'.tr(),
                  controller: _subjectController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'field_required'.tr();
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                
                CustomTextField(
                  title: 'message'.tr(),
                  hint: 'complaint_message_hint'.tr(),
                  controller: _messageController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'field_required'.tr();
                    return null;
                  },
                ),

                SizedBox(height: 24.h),
                
                BlocBuilder<ComplaintCubit, ComplaintState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'submit_complaint'.tr(),
                      isLoading: state is ComplaintActionLoading,
                      onPressed: _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ComplaintCubit>().sendMessage(
        message: _messageController.text,
        complaintId: 8,
      );
    }
  }
}
