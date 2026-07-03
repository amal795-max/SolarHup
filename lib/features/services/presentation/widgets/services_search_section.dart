import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class ServicesSearchSection extends StatefulWidget {
  const ServicesSearchSection({super.key});

  @override
  State<ServicesSearchSection> createState() => _ServicesSearchSectionState();
}

class _ServicesSearchSectionState extends State<ServicesSearchSection> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextField(
            hasTitle: false,
            title: '',
            controller: _controller,
            hint: 'services_search_hint'.tr(),
            onChanged: (value) => context
                .read<ServicesBloc>()
                .add(UpdateServicesSearchEvent(value)),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.grey,
              size: 20.sp,
            ),
            suffixIcon: _hasText
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.grey,
                      size: 18.sp,
                    ),
                    onPressed: () {
                      _controller.clear();
                      context
                          .read<ServicesBloc>()
                          .add(const UpdateServicesSearchEvent(''));
                    },
                  )
                : null,
          ),
        ),
        SizedBox(width: 10.w),
        Material(
          color: isDark ? theme.colorScheme.surface : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 48.w,
              height: 48.h,
              child: Icon(
                Icons.tune_rounded,
                color: AppColors.white,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
