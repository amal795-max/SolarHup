import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/error_retry_guard.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../core/theme/app_colors.dart';
import 'empty_widget.dart';

Widget errorWidget({
  required String message,
  void Function()? onPressed,
  required bool hasButton,
}) {
  if (!hasButton || onPressed == null) {
    return EmptyWidget(
      icon: Icons.error_outline,
      iconSize: 56,
      iconColor: AppColors.red,
      title: 'stores_error_title',
      subtitle: message.tr(),
    );
  }

  return _ErrorRetryView(message: message, onRetry: onPressed);
}

class _ErrorRetryView extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetryView({
    required this.message,
    required this.onRetry,
  });

  @override
  State<_ErrorRetryView> createState() => _ErrorRetryViewState();
}

class _ErrorRetryViewState extends State<_ErrorRetryView> {
  late final String _routeKey;

  @override
  void initState() {
    super.initState();
    _routeKey = ErrorRetryGuard.routeKey(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ErrorRetryGuard.shouldRedirectHome(_routeKey)) {
        ErrorRetryGuard.clear(_routeKey);
        context.go(AppRoutes.bottomNavBar);
      }
    });
  }

  void _handleRetry() {
    ErrorRetryGuard.recordRetry(_routeKey);
    if (ErrorRetryGuard.shouldRedirectHome(_routeKey)) {
      ErrorRetryGuard.clear(_routeKey);
      context.go(AppRoutes.bottomNavBar);
      return;
    }
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      icon: Icons.error_outline,
      iconSize: 56,
      iconColor: AppColors.red,
      title: 'stores_error_title',
      subtitle: widget.message.tr(),
      action: CustomButton(
        width: 0.6.sw,
        text: 'stores_retry'.tr(),
        icon: Icons.refresh_rounded,
        iconLeft: true,
        onPressed: _handleRetry,
      ),
    );
  }
}
