import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/features/services/presentation/bloc/schedule_service_bloc/schedule_service_bloc.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class ScheduleFormSection extends StatefulWidget {
  const ScheduleFormSection({super.key});

  @override
  State<ScheduleFormSection> createState() => _ScheduleFormSectionState();
}

class _ScheduleFormSectionState extends State<ScheduleFormSection> {
  late final TextEditingController _priorityController;
  late final TextEditingController _panelsController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _priorityController = TextEditingController();
    _panelsController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _priorityController.dispose();
    _panelsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          title: 'schedule_priority_label'.tr(),
          controller: _priorityController,
          onChanged: (value) => context
              .read<ScheduleServiceBloc>()
              .add(UpdateSchedulePriorityEvent(value)),
        ),
        CustomTextField(
          title: 'schedule_panels_number_label'.tr(),
          controller: _panelsController,
          keyboardType: TextInputType.number,
          onChanged: (value) => context
              .read<ScheduleServiceBloc>()
              .add(UpdateSchedulePanelsEvent(value)),
        ),
        CustomTextField(
          title: 'schedule_notes_label'.tr(),
          controller: _notesController,
          isMultiline: true,
          maxLines: 4,
          onChanged: (value) => context
              .read<ScheduleServiceBloc>()
              .add(UpdateScheduleNotesEvent(value)),
        ),
      ],
    );
  }
}
