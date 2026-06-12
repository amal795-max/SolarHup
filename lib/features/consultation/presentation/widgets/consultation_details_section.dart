import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';

class ConsultationDetailsSection extends StatelessWidget {
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
        _ConsultationField(
          label: 'consultation_full_name'.tr(),
          value: fullName,
          filled: true,
          onChanged: (v) =>
              context.read<BookConsultationBloc>().add(UpdateFullNameEvent(v)),
        ),
        _ConsultationField(
          label: 'consultation_phone'.tr(),
          value: phone,
          filled: true,
          keyboardType: TextInputType.phone,
          onChanged: (v) =>
              context.read<BookConsultationBloc>().add(UpdatePhoneEvent(v)),
        ),
        _ConsultationField(
          label: 'consultation_address'.tr(),
          value: address,
          filled: false,
          onChanged: (v) =>
              context.read<BookConsultationBloc>().add(UpdateAddressEvent(v)),
        ),
        _ConsultationField(
          label: 'consultation_notes'.tr(),
          value: notes,
          filled: false,
          hint: 'consultation_notes_hint'.tr(),
          isMultiline: true,
          onChanged: (v) =>
              context.read<BookConsultationBloc>().add(UpdateNotesEvent(v)),
        ),
      ],
    );
  }
}

class _ConsultationField extends StatefulWidget {
  final String label;
  final String value;
  final String? hint;
  final bool filled;
  final bool isMultiline;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _ConsultationField({
    required this.label,
    required this.value,
    required this.filled,
    required this.onChanged,
    this.hint,
    this.isMultiline = false,
    this.keyboardType,
  });

  @override
  State<_ConsultationField> createState() => _ConsultationFieldState();
}

class _ConsultationFieldState extends State<_ConsultationField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _ConsultationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            maxLines: widget.isMultiline ? 4 : 1,
            onChanged: widget.onChanged,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodySmall,
              filled: widget.filled,
              fillColor: widget.filled
                  ? theme.colorScheme.tertiaryContainer
                  : theme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: widget.isMultiline ? 14.h : 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
