import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/enums/product_status_enum.dart';
import 'package:untitled1/core/enums/region_enum.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';
import 'package:untitled1/features/used_system/presentation/widgets/drop_menu_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String? selectedCondition;
  String? selectedRegion;

  final List<String> conditions = ProductStatusEnum.values
      .map((e) => e.status)
      .toList();
  final List<String> regions = RegionEnum.values.map((e) => e.region).toList();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<UsedSystemCubit>();
    selectedCondition = cubit.filterCondition;
    selectedRegion = cubit.filterRegion;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsedSystemCubit>();
    return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          spacing: 24.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('filters'.tr(), style: AppStyle.bodyMedium),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCondition = null;
                      selectedRegion = null;
                    });
                    cubit.clearFilters();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'reset_all'.tr(),
                      style: AppStyle.labelSmall.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),   ],
            ),
            DropdownField(
              title: 'condition'.tr(),
              value: selectedCondition,
              items: conditions,
              onChanged: (value) {
                setState(() {
                  selectedCondition = value;
                });
              },
            ),
            DropdownField(
              title: 'region'.tr(),
              value: selectedRegion,
              items: regions,
              onChanged: (value) {
                setState(() {
                  selectedRegion = value;
                });
              },
            ),
            CustomButton(
              text: 'apply_filters',
              onPressed: () {
                cubit.setFilters(
                  condition: selectedCondition,
                  region: selectedRegion,
                );
                Navigator.pop(context);
              },
            ),
          ],
      ),
    );
  }
}
