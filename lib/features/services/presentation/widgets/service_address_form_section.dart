import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/service_address_bloc/service_address_bloc.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class ServiceAddressFormSection extends StatefulWidget {
  final ServiceAddressLoaded state;

  const ServiceAddressFormSection({super.key, required this.state});

  @override
  State<ServiceAddressFormSection> createState() =>
      _ServiceAddressFormSectionState();
}

class _ServiceAddressFormSectionState extends State<ServiceAddressFormSection> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.state.fullName);
    _streetController = TextEditingController(text: widget.state.streetAddress);
    _cityController = TextEditingController(text: widget.state.city);
    _buildingController = TextEditingController(text: widget.state.building);
    _floorController = TextEditingController(text: widget.state.floor);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final hints = widget.state.address;

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: headingColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'address_details_label'.tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: headingColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            title: 'full_name'.tr(),
            hint: hints.defaultFullName,
            controller: _fullNameController,
            onChanged: (value) => context
                .read<ServiceAddressBloc>()
                .add(UpdateServiceFullNameEvent(value)),
          ),
          CustomTextField(
            title: 'street_address'.tr(),
            hint: hints.defaultStreetAddress,
            controller: _streetController,
            onChanged: (value) => context
                .read<ServiceAddressBloc>()
                .add(UpdateServiceStreetEvent(value)),
          ),
          CustomTextField(
            title: 'city'.tr(),
            hint: hints.defaultCity,
            controller: _cityController,
            onChanged: (value) => context
                .read<ServiceAddressBloc>()
                .add(UpdateServiceCityEvent(value)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  title: 'address_building_label'.tr(),
                  hint: hints.defaultBuilding,
                  controller: _buildingController,
                  onChanged: (value) => context
                      .read<ServiceAddressBloc>()
                      .add(UpdateServiceBuildingEvent(value)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  title: 'address_floor_label'.tr(),
                  hint: hints.defaultFloor,
                  controller: _floorController,
                  onChanged: (value) => context
                      .read<ServiceAddressBloc>()
                      .add(UpdateServiceFloorEvent(value)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
