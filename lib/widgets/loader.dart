import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled1/core/theme/app_colors.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key,});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: LoadingAnimationWidget.flickr(
            leftDotColor: AppColors.primaryColor,
            rightDotColor: AppColors.secondaryColor,
            size: 60.r,
          ),
      ),
    );
  }
}
