import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:untitled1/core/helper/auth_session.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final onboardingCompleted = LocalStorage().getData(
      key: StorageKeys.onboardingCompleted,
      defaultValue: false,
    ) ?? false;

    if (!onboardingCompleted) {
      context.go(AppRoutes.onboardingScreen);
      return;
    }

    if (AuthSession.isLoggedIn) {
      if (!mounted) return;
      context.read<FavoritesCubit>().prefetchInitialFavorites();
      context.go(AppRoutes.bottomNavBar);
    } else {
      await AuthSession.clear();
      context.go(AppRoutes.authenticationScreen);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.primaryColor)),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                              padding: EdgeInsets.all(18.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.07),
                                ),
                              ),
                              child: Image.asset(
                                AppImages.logoImage,
                                width: 85.r,
                                height: 85.r,
                                color: AppColors.white,
                              ),
                            )
                            .animate()
                            .fade(duration: 600.ms)
                            .scale(begin: const Offset(0.93, 0.93)),

                        SizedBox(height: 24.h),

                        Text(
                          'TOPSOLAR',
                          textAlign: TextAlign.center,
                          style: AppStyle.h2
                              .copyWith(
                                color: Colors.white,
                                letterSpacing: 6,
                              ),
                        ).animate(delay: 150.ms).fade(duration: 500.ms),

                        SizedBox(height: 10.h),

                        Text(
                          'splash_subtitle'.tr(),
                          textAlign: TextAlign.center,
                          style:AppStyle.bodySmall
                              .copyWith(
                                color: AppColors.blue,
                                letterSpacing: 1.5,
                              ),
                        ).animate(delay: 300.ms).fade(duration: 500.ms),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 60.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              color: Colors.white.withOpacity(0.6),
                              backgroundColor: Colors.white.withOpacity(0.1),
                              minHeight: 2.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          'v1.0.0',
                          style:AppStyle.labelSmall.copyWith(
                                color: Colors.white.withOpacity(0.25),
                                letterSpacing: 1,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
