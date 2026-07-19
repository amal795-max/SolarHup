import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled1/core/theme/app_colors.dart';


class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key,});


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
  }}

GlobalKey<State> loaderKey = GlobalKey<State>();

void showLoader(BuildContext context) {
  showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return  const LoadingIndicator();
    },

  ).then((_) => loaderKey.currentState?.dispose());
}
