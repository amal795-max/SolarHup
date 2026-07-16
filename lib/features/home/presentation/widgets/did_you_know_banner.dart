import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class DidYouKnowBanner extends StatefulWidget {
  const DidYouKnowBanner({super.key});

  @override
  State<DidYouKnowBanner> createState() => _DidYouKnowBannerState();
}
class _DidYouKnowBannerState extends State<DidYouKnowBanner> {
  final PageController _controller = PageController(viewportFraction: 0.88);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_controller.hasClients) {
          int nextPage = _currentIndex + 1;

          if (nextPage >= 3) {
            nextPage = 0;
          }

          _controller.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  final List<Map<String, String>> tips = [
    {
      'title': 'tip_1_title',
      'body': 'tip_1_body'
    },
    {
      'title': 'tip_2_title',
      'body':'tip_2_body'
    },
    {
      'title': 'tip_3_title',
      'body': 'tip_3_body'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(
            height: 130.h,
            child: PageView.builder(
              controller: _controller,
              itemCount: tips.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color:AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: const [

                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tips[index]['title']!.tr(),
                            style: AppStyle.bodySmall.copyWith(
                              color: AppColors.lightGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Icon(Icons.tips_and_updates,color: AppColors.secondaryColor,),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        tips[index]['body']!.tr(),
                        style: AppStyle.bodyXSmall.copyWith(
                          color: AppColors.blue,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 12.h),

          // Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              tips.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentIndex == index ? 20.w : 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.tertiaryColor
                      : AppColors.tertiaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ],

    );
  }
}
