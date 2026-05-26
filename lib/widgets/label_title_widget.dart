import 'package:flutter/material.dart';

import '../core/theme/app_style.dart';


class LabelWidget extends StatelessWidget {
  const LabelWidget({super.key, this.title, this.more, this.onTap});

  final String? title;
  final String? more;
  final dynamic Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? '', style: AppStyle.labelMedium),
          InkWell(
            onTap: onTap,
            child: Text(more ?? 'View All', style: AppStyle.labelMoreStyle),
          ),
        ],

    );
  }
}
