import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/auth_session.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';
import 'package:untitled1/core/helper/user_city_preference.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/authentication/presentation/widgets/white_section_widget.dart';
import 'package:untitled1/features/home/presentation/bloc/application_cubit.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/primary_button.dart';
import 'package:untitled1/widgets/region_picker_dialog.dart';

import '../../../../core/helper/extensions.dart';
import '../../../used_system/presentation/bloc/used_system_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr(), style: AppStyle.h5)),
      body: AppRefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: appRefreshPhysics,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'account_section'.tr()),
              _buildSectionCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.language,
                  title: 'language'.tr(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.locale.languageCode.toUpperCase(),
                        style: AppStyle.bodySmall,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 20.sp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () => _showLanguageDialog(context),
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: UserCityPreference.cityNotifier,
                  builder: (context, selectedCity, _) {
                    final cityLabel =
                        selectedCity == null || selectedCity.isEmpty
                        ? 'city_not_set'.tr()
                        : selectedCity.tr();
                    return _buildListTile(
                      context,
                      icon: Icons.location_city_outlined,
                      title: 'city'.tr(),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cityLabel, style: AppStyle.bodySmall),
                          Icon(
                            Icons.chevron_right,
                            size: 20.sp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: () => _showCityDialog(context),
                    );
                  },
                ),
                _buildDarkModeTile(context),

                _buildListTile(
                  context,
                  icon: Icons.favorite_border,
                  title: 'my_favorites'.tr(),
                  onTap: () => context.push(AppRoutes.favoritesScreen),
                ),
                _buildListTile(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'my_complaints'.tr(),
                  onTap: () => context.push(AppRoutes.myComplaintsScreen),
                ),
                _buildListTile(
                  context,
                  icon: Icons.bar_chart,
                  title: 'my_used_products'.tr(),
                  onTap: () {
                    context.push(AppRoutes.myListeningScreen);
                    context.read<UsedSystemCubit>().getMyUsedProducts();
                  },
                ),
              ]),

              SizedBox(height: 20.h),

              _buildSectionHeader(context, 'security_section'.tr()),
              _buildSectionCard(context, [
                _buildListTile(
                  onTap: () => context.push(AppRoutes.changePasswordScreen),
                  context,
                  icon: Icons.lock_outline,
                  title: 'change_password'.tr(),
                ),
              ]),

              SizedBox(height: 20.h),

              _buildSectionHeader(context, 'content_section'.tr()),
              _buildSectionCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.article_outlined,
                  title: 'blog'.tr(),
                  onTap: () => context.push(AppRoutes.blogScreen),
                ),
                _buildListTile(
                  context,
                  icon: Icons.quiz_outlined,
                  title: 'q_a'.tr(),
                  onTap: () => context.push(AppRoutes.allQuestionsScreen),
                ),
              ]),

              SizedBox(height: 20.h),

              _buildSectionHeader(context, 'legal_section'.tr()),
              _buildSectionCard(context, [
                _buildListTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'privacy_policy'.tr(),
                  onTap: () => context.push(AppRoutes.privacyPolicyScreen),
                ),
              ]),

              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'logout'.tr(),
                  type: ButtonType.outlined,
                  borderColor: AppColors.red,
                  textColor: AppColors.red,
                  onPressed: () async {
                    getIt<PromotionEligibilityService>().clear();
                    await AuthSession.clear();
                    if (context.mounted) {
                      context.go(AppRoutes.authenticationScreen);
                    }
                  },
                ),
              ),
              SizedBox(height: 20.h),
              const Center(child: Text('Version 0.0.1')),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    return whiteSectionWidget(
      padding: 0,
      child: Column(
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget child = entry.value;
          if (idx == children.length - 1) return child;
          return Column(
            children: [
              child,
              Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
            ],
          );
        }).toList(),
      ),
      context: context,
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22.sp),
      title: Text(title, style: AppStyle.bodySmall),
      trailing:
          trailing ??
          Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  Widget _buildDarkModeTile(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        bool isDark = false;
        if (state is ApplicationMainState) {
          isDark = context.brightness;
        }
        return _buildSwitchTile(
          context,
          icon: Icons.dark_mode_outlined,
          title: 'dark_mode'.tr(),
          value: isDark,
          onChanged: (val) {
            context.read<ApplicationCubit>().toggleTheme();
          },
        );
      },
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22.sp),
      title: Text(title, style: AppStyle.bodySmall),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.secondaryColor,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      dense: true,
    );
  }

  void _showCityDialog(BuildContext context) async {
    final selected = await showRegionPickerDialog(
      context,
      selectedRegion: UserCityPreference.selectedRegion,
    );
    if (selected == null || !context.mounted) return;
    await UserCityPreference.setSelectedRegion(selected);
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('language'.tr(), style: AppStyle.bodyMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English', style: AppStyle.bodySmall),
                trailing: context.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  context.read<ApplicationCubit>().changeLanguage(
                    context,
                    'en',
                  );
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: Text('العربية', style: AppStyle.bodySmall),
                trailing: context.locale.languageCode == 'ar'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  context.read<ApplicationCubit>().changeLanguage(
                    context,
                    'ar',
                  );
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
