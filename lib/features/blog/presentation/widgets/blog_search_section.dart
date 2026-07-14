import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_cubit.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class BlogSearchSection extends StatefulWidget {
  const BlogSearchSection({super.key});

  @override
  State<BlogSearchSection> createState() => _BlogSearchSectionState();
}

class _BlogSearchSectionState extends State<BlogSearchSection> {
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
    return CustomTextField(
      hasTitle: false,
      title: '',
      controller: _controller,
      hint: 'blog_search_hint'.tr(),
      onChanged: (value) => context.read<BlogCubit>().updateSearch(value),
      prefixIcon: Icon(Icons.search_rounded, color: AppColors.grey, size: 20.sp),
      suffixIcon: _hasText
          ? IconButton(
              icon: Icon(Icons.close_rounded, color: AppColors.grey, size: 18.sp),
              onPressed: () {
                _controller.clear();
                context.read<BlogCubit>().updateSearch('');
              },
            )
          : null,
    );
  }
}
