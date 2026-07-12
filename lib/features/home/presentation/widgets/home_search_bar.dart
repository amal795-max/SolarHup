import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool enabled;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.enabled = true,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(HomeSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
        hasTitle: false,
        title: '',
        controller: widget.controller,
        hint: 'home_search_hint'.tr(),
        readOnly: !widget.enabled,
        onChanged: widget.onChanged,
        prefixIcon: Icon(Icons.search, color: AppColors.grey, size: 20.sp),
        suffixIcon: _hasText
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.grey,
                  size: 18.sp,
                ),
                onPressed: () {
                  widget.controller.clear();
                  widget.onClear?.call();
                },
                splashRadius: 18,
              )
            : null,

    );
  }
}
