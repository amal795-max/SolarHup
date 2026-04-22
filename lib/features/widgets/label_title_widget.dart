import "package:flutter/material.dart";
import "package:get/get.dart";
import "../../core/constants/app_colors.dart";
import "../../core/constants/app_style.dart";
import "../../core/util/helper/data_helper.dart";
import "animation.dart";

class LabelWidget extends StatelessWidget {
  const LabelWidget({super.key, this.title, this.more, this.onTap});

  final String? title;
  final String? more;
  final dynamic Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return WashingAnimation(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? "", style: AppStyle.labelStyle.copyWith(color: DataHelper.isDarkTheme(Get.context!)? AppColors.white : AppColors.black,))  ,
          InkWell(
            onTap: onTap,
            child: Text(more ?? "View All".tr, style: AppStyle.labelMoreStyle),
          ),
        ],
      ),
    );
  }
}
