import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/app_images.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/application_cubit.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
          accountName: Text('Amal Haboosh'),
          accountEmail: Text('amal@example.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage(AppImages.solrPanelsIcon),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.favorite_border),
          title: Text('my_favorite'.tr()),
        ),

        ListTile(
          leading: const Icon(Icons.discount_outlined),
          title: Text('my_discounts'.tr()),
          onTap: () {
            context.push(AppRoutes.discountsScreen);
          },
        ),

        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: Text('blog'.tr()),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.language),
          title: Text('language'.tr()),
          trailing: Text(context.locale.languageCode.toUpperCase()),
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text('language'.tr()),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          context.read<ApplicationCubit>().changeLanguage(context, 'en');
                          Navigator.pop(dialogContext);
                        },
                        trailing: context.locale.languageCode == 'en' ? const Icon(Icons.check, color: Colors.green) : null,
                      ),
                      ListTile(
                        title: const Text('العربية'),
                        onTap: () {
                          context.read<ApplicationCubit>().changeLanguage(context, 'ar');
                          Navigator.pop(dialogContext);
                        },
                        trailing: context.locale.languageCode == 'ar' ? const Icon(Icons.check, color: Colors.green) : null,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.report_problem_outlined),
          title: Text('complaints'.tr()),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.dark_mode_outlined),
          title: Text('dark_mode'.tr()),
          trailing: BlocBuilder<ApplicationCubit, ApplicationState>(
            builder: (context, state) {
              bool isDark = false;
              if (state is ApplicationMainState) {
                isDark = state.themeMode == ThemeMode.dark;
                print(isDark);
              }
              return Switch(
                activeThumbColor: AppColors.secondaryColor,
                value: isDark,
                onChanged: (val) {
                  context.read<ApplicationCubit>().toggleTheme();
                },
              );
            },
          ),
        ),


        const Divider(),

        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text('terms_conditions'.tr()),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text('privacy_policy'.tr()),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(
            'logout'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () {},
        ),
      ],
    ),
  );
}
