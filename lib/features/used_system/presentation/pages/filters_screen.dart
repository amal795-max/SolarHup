import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

import '../widgets/category_chip.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues _currentRangeValues = const RangeValues(0, 10000);
  bool _ecoPowerChecked = true;
  bool _sunPowerChecked = false;
  bool _voltMastersChecked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('filters'.tr(), style: theme.textTheme.titleMedium),
        actions: [
          TextButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'reset_all'.tr(),
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'categories'.tr()),
                  SizedBox(height: 12.h),
                  const CategoryFilterSection(),
                  SizedBox(height: 24.h),
                  _SectionTitle(
                    title: 'price_range'.tr(),
                    trailing: Text('\$${_currentRangeValues.start.round()} - \$${_currentRangeValues.end.round()}+',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primaryColor)),
                  ),
                  RangeSlider(
                    values: _currentRangeValues,
                    max: 10000,
                    activeColor: Colors.amber,
                    inactiveColor: AppColors.lightGrey,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: 'city'.tr()),
                  SizedBox(height: 12.h),
                  const _CityDropdown(),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(child: _PriceInput(label: 'min_price'.tr(), value: '0')),
                      SizedBox(width: 15.w),
                      Expanded(child: _PriceInput(label: 'max_price'.tr(), value: '10,000')),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  const _PriceShortcuts(),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: 'brands'.tr()),
                  SizedBox(height: 12.h),
                  _BrandsList(
                    ecoPower: _ecoPowerChecked,
                    sunPower: _sunPowerChecked,
                    voltMasters: _voltMastersChecked,
                    onEcoChanged: (v) => setState(() => _ecoPowerChecked = v!),
                    onSunChanged: (v) => setState(() => _sunPowerChecked = v!),
                    onVoltChanged: (v) => setState(() => _voltMastersChecked = v!),
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: 'technical_specs'.tr()),
                  SizedBox(height: 12.h),
                  const _TechnicalSpecsList(),
                  SizedBox(height: 24.h),
                  const _FeaturedBanner(),
                ],
              ),
            ),
          ),
          const _ApplyButton(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        ?trailing,
      ],
    );
  }
}



class _CityDropdown extends StatelessWidget {
  const _CityDropdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text('city'.tr()),
          items: const [
            DropdownMenuItem(child: Text('Damascus'))
          ],
          onChanged: (v) {},
        ),
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  final String label;
  final String value;

  const _PriceInput({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.sp)),
        SizedBox(height: 6.h),
        TextField(
          controller: TextEditingController(text: '\$ $value'),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          ),
        ),
      ],
    );
  }
}

class _PriceShortcuts extends StatelessWidget {
  const _PriceShortcuts();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        _ShortCutChip(label: 'under_500'.tr()),
        _ShortCutChip(label: 'price_500_2000'.tr()),
        _ShortCutChip(label: 'price_2k_5k'.tr()),
        _ShortCutChip(label: 'price_5k_plus'.tr()),
      ],
    );
  }
}

class _ShortCutChip extends StatelessWidget {
  final String label;

  const _ShortCutChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp)),
    );
  }
}

class _BrandsList extends StatelessWidget {
  final bool ecoPower;
  final bool sunPower;
  final bool voltMasters;
  final Function(bool?) onEcoChanged;
  final Function(bool?) onSunChanged;
  final Function(bool?) onVoltChanged;

  const _BrandsList({
    required this.ecoPower,
    required this.sunPower,
    required this.voltMasters,
    required this.onEcoChanged,
    required this.onSunChanged,
    required this.onVoltChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            value: ecoPower,
            onChanged: onEcoChanged,
            title: Text('eco_power'.tr()),
            secondary: const Icon(Icons.factory_outlined),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.secondaryColor,
            checkColor: AppColors.brown,
          ),
          CheckboxListTile(
            value: sunPower,
            onChanged: onSunChanged,
            title: Text('sun_power'.tr()),
            secondary: const Icon(Icons.wb_sunny_outlined),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.secondaryColor,
            checkColor: AppColors.brown,
          ),
          CheckboxListTile(
            value: voltMasters,
            onChanged: onVoltChanged,
            title: Text('volt_masters'.tr()),
            secondary: const Icon(Icons.bolt_outlined),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.secondaryColor,
            checkColor: AppColors.brown,
          ),
        ],
      ),
    );
  }
}

class _TechnicalSpecsList extends StatelessWidget {
  const _TechnicalSpecsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ExpandableSpec(
          title: 'efficiency_rating'.tr(),
          isExpanded: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('efficiency_hint'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.sp)),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const _SmallChip(label: '15% - 18%'),
                  SizedBox(width: 8.w),
                  const _SmallChip(label: '19% - 21%', isSelected: true),
                  SizedBox(width: 8.w),
                  const _SmallChip(label: '22%+'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _ExpandableSpec(title: 'battery_capacity'.tr()),
        SizedBox(height: 12.h),
        _ExpandableSpec(title: 'inverter_type'.tr()),
      ],
    );
  }
}

class _ExpandableSpec extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final Widget? content;

  const _ExpandableSpec({required this.title, this.isExpanded = false, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        title: Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        children: [
          if (content != null) Padding(padding: EdgeInsets.all(16.w), child: content!),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _SmallChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.amber[100] : AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6.r),
        border: isSelected ? Border.all(color: Colors.amber) : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(fontSize: 8.sp, color: isSelected ? Colors.orange[800] : null, fontWeight: isSelected ? FontWeight.bold : null),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=60'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(16.w),
      child: Text(
        'featured_collection'.tr(),
        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('apply_filters'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8.w),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              child: const Text('42', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
