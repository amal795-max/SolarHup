import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/enums/region_enum.dart';
import 'package:untitled1/core/theme/app_style.dart';

Future<String?> showRegionPickerDialog(
  BuildContext context, {
  String? selectedRegion,
}) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('city'.tr(), style: AppStyle.bodyMedium),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: RegionEnum.values.map((region) {
              final isSelected = region.region == selectedRegion;
              return ListTile(
                title: Text(region.region.tr(), style: AppStyle.bodySmall),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () => Navigator.pop(dialogContext, region.region),
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
