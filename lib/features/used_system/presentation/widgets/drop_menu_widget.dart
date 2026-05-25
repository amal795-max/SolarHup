import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

class DropdownField extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  final valueListenable = ValueNotifier<String?>(null);
   DropdownField({super.key, required this.title, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(title, style:theme.textTheme.labelSmall),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint:  Text(
              'select_item'.tr(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            items: items.map((String item) => DropdownItem<String>(
              value: item,
              height: 40,
              child: Text(
                item,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            )
                .toList(),
            valueListenable: valueListenable,
            onChanged: (value) {
              valueListenable.value = value;
            },
            buttonStyleData: ButtonStyleData(
              height: 55.h,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color:AppColors.borderColor), color: AppColors.white,),

            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              iconEnabledColor: Colors.grey,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200.h,
              width: 150.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(4),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ],
    );
  }
}
