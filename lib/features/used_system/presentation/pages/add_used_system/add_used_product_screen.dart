import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'add_details_step.dart';
import 'add_media_step.dart';
import 'add_technical_step.dart';

class AddUsedProductScreen extends StatefulWidget {
  const AddUsedProductScreen({super.key});

  @override
  State<AddUsedProductScreen> createState() => _AddUsedProductScreenState();
}

class _AddUsedProductScreenState extends State<AddUsedProductScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _StepIndicator(currentStep: _currentStep),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  DetailsStep(onNext: _nextStep),
                  TechnicalStep(onNext: _nextStep),
                  const MediaStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepCircle(number: 1, label: 'details'.tr(), isActive: currentStep >= 0),
          _StepLine(isActive: currentStep >= 1),
          _StepCircle(number: 2, label: 'technical'.tr(), isActive: currentStep >= 1),
          _StepLine(isActive: currentStep >= 2),
          _StepCircle(number: 3, label: 'media'.tr(), isActive: currentStep >= 2),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;

  const _StepCircle({required this.number, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primaryColor : AppColors.lightGrey,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,

              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isActive ? AppColors.primaryColor : AppColors.grey,
            fontWeight: isActive ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;
  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(bottom: 20.h),
        color: isActive ? AppColors.primaryColor : AppColors.lightGrey,
      ),
    );
  }
}





