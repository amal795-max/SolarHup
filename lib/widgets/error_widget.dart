import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../core/theme/app_colors.dart';
import 'empty_widget.dart';

Widget errorWidget({required String message, void Function()? onPressed,  required bool hasButton}){
  return EmptyWidget(
    icon: Icons.error_outline,
    iconSize: 56,
    iconColor: AppColors.red,
    title: 'stores_error_title',
    subtitle: message,
    action: hasButton? CustomButton(
      text: 'stores_retry'.tr(),
      icon: Icons.refresh_rounded,
      iconLeft: true,
      onPressed:  onPressed
    ):null,
  );

}