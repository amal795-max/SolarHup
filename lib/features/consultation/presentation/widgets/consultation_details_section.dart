import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class ConsultationDetailsSection extends StatefulWidget {
  final String fullName;
  final String phone;
  final String address;
  final String notes;

  const ConsultationDetailsSection({
    super.key,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.notes,
  });

  @override
  State<ConsultationDetailsSection> createState() =>
      _ConsultationDetailsSectionState();
}

class _ConsultationDetailsSectionState extends State<ConsultationDetailsSection> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
    _notesController = TextEditingController(text: widget.notes);
  }

  @override
  void didUpdateWidget(covariant ConsultationDetailsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fullName != widget.fullName &&
        _fullNameController.text != widget.fullName) {
      _fullNameController.text = widget.fullName;
    }
    if (oldWidget.phone != widget.phone &&
        _phoneController.text != widget.phone) {
      _phoneController.text = widget.phone;
    }
    if (oldWidget.address != widget.address &&
        _addressController.text != widget.address) {
      _addressController.text = widget.address;
    }
    if (oldWidget.notes != widget.notes &&
        _notesController.text != widget.notes) {
      _notesController.text = widget.notes;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'consultation_details_title'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          controller: _fullNameController,
          title: 'consultation_full_name'.tr(),
          onChanged: (value) => context
              .read<BookConsultationBloc>()
              .add(UpdateFullNameEvent(value)),
        ),
        CustomTextField(
          controller: _phoneController,
          title: 'consultation_phone'.tr(),
          keyboardType: TextInputType.phone,
          onChanged: (value) =>
              context.read<BookConsultationBloc>().add(UpdatePhoneEvent(value)),
        ),
        CustomTextField(
          controller: _addressController,
          title: 'consultation_address'.tr(),
          onChanged: (value) => context
              .read<BookConsultationBloc>()
              .add(UpdateAddressEvent(value)),
        ),
        CustomTextField(
          controller: _notesController,
          title: 'consultation_notes'.tr(),
          hint: 'consultation_notes_hint'.tr(),
          isMultiline: true,
          onChanged: (value) =>
              context.read<BookConsultationBloc>().add(UpdateNotesEvent(value)),
        ),
      ],
    );
  }
}
