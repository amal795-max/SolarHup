import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class DidYouKnowBanner extends StatefulWidget {
  const DidYouKnowBanner({super.key});

  @override
  State<DidYouKnowBanner> createState() => _DidYouKnowBannerState();
}

class _DidYouKnowBannerState extends State<DidYouKnowBanner> {
  final PageController _controller = PageController(viewportFraction: 0.88);
  int _currentIndex = 0;

  final List<Map<String, String>> tips = [
    {
      'title': 'هل تعلم؟',
      'body': 'تنظيف الألواح الشمسية بشكل دوري يزيد إنتاج الطاقة بنسبة قد تصل إلى 15٪.'
    },
    {
      'title': 'نصيحة الطاقة',
      'body': 'تجنب تفريغ البطارية بالكامل للحفاظ على عمرها الافتراضي.'
    },
    {
      'title': 'معلومة مهمة',
      'body': 'اختيار زاوية تركيب مناسبة يمكن أن يرفع كفاءة النظام بشكل كبير.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.h,
      child: Column(
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
                      Text(
                        tips[index]['title']!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.lightGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        tips[index]['body']!,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
      ),
    );
  }
}
