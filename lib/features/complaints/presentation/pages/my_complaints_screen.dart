import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';
import 'package:untitled1/features/complaints/presentation/bloc/complaint_cubit.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../widget/complaint_card.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ComplaintCubit>().getMyComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_complaints'.tr()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addComplaintScreen),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: CustomTextField(
              hasTitle: false,
              title: '',
              hint: 'search_ticket_id'.tr(),
              prefixIcon: const Icon(Icons.search),
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
            ),
          ),
          _buildFilters(),
          Expanded(
            child: BlocBuilder<ComplaintCubit, ComplaintState>(
              builder: (context, state) {
                if (state is ComplaintError) {
                  return EmptyWidget(
                    icon: Icons.error_outline_rounded,
                    title: 'error'.tr(),
                    subtitle: state.message,
                    action: CustomButton(
                      text: 'retry'.tr(),
                      onPressed: () => context.read<ComplaintCubit>().getMyComplaints(),
                    ),
                  );
                }
                List<ComplaintModel> complaints = [];

                final isLoading = state is ComplaintLoading;

                if (isLoading) {
                  complaints = List.generate(
                    4,
                        (index) => ComplaintModel(
                      id: index,
                      customerId: 0,
                      customerPhone: '',
                      businessId: 0,
                      businessName: 'Business Name',
                      subject: 'Loading complaint subject...',
                      status: 'pending',
                      messages: [],
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                }
                else if (state is ComplaintSuccess) {
                  complaints = state.complaints.where((c) {
                    final matchesFilter =
                        _selectedFilter == 'all' ||
                            c.status.toLowerCase() == _selectedFilter;

                    final matchesSearch =
                        c.id.toString().contains(_searchQuery) ||
                            c.subject.toLowerCase().contains(_searchQuery.toLowerCase());

                    return matchesFilter && matchesSearch;
                  }).toList();
                }
                else {
                  complaints = context.read<ComplaintCubit>().complaints;
                }

                if (state is ComplaintSuccess && complaints.isEmpty) {
                  return EmptyWidget(
                    icon: Icons.assignment_late_outlined,
                    title: 'no_complaints_found'.tr(),
                    subtitle: 'no_complaints_desc'.tr(),
                  );
                }

                return Skeletonizer(
                  enabled: isLoading,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintCard(complaint: complaints[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['all', 'resolved', 'open'];
    return SizedBox(
      height: 48.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return ChoiceChip(
            checkmarkColor: AppColors.white,
            label: Text(filter.tr()),
            selected: isSelected,
            onSelected: (val) {
              if (val) setState(() => _selectedFilter = filter);
            },
            selectedColor: AppColors.primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.deepGrey,
              fontSize: 12.sp,
            ),
          );
        },
      ),
    );
  }
}


