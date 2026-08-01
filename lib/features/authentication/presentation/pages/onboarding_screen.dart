import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/core/theme/app_style.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<String> titleKeys = [
    'onboarding_title_1',
    'onboarding_title_2',
    'onboarding_title_3',
  ];

  final List<String> descriptionKeys = [
    'onboarding_desc_1',
    'onboarding_desc_2',
    'onboarding_desc_3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.onboardingImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.4),
                    AppColors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            bottom: 180.h,
            child: PageView.builder(
              controller: controller,
              itemCount: titleKeys.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleKeys[index].tr(),
                        style: AppStyle.h1.copyWith(
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        descriptionKeys[index].tr(),
                        style: AppStyle.bodyMedium.copyWith(
                          color: AppColors.grey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ).animate()
                      .slideX(begin: -0.2, end: 0, duration: 500.ms),
                );
              },
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        titleKeys.length,
                            (dotIndex) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          width: currentIndex == dotIndex ? 24.w : 8.w,
                          height: 7.h,
                          decoration: BoxDecoration(
                            color: currentIndex == dotIndex
                                ? AppColors.secondaryColor
                                : AppColors.deepGrey,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    CustomButton(
                      text: currentIndex == 2 ? 'invest_now_btn' : 'onboarding_next',
                      type: currentIndex == 2 ? ButtonType.filled : ButtonType.outlined,

                      backgroundColor: currentIndex == 2 ? AppColors.secondaryColor : Colors.black45,
                      textColor: currentIndex == 2 ? Colors.black : Colors.white,
                      borderColor: currentIndex == 2 ? Colors.transparent : Colors.white.withOpacity(0.15),


                      onPressed: () async{
                        if (currentIndex == 2) {
                          await LocalStorage().saveData(key: StorageKeys.onboardingCompleted, value: true);
                          context.push(AppRoutes.authenticationScreen);

                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
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