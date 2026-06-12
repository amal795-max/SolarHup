import 'package:equatable/equatable.dart';

class ExpertModel extends Equatable {
  final String id;
  final String name;
  final String role;
  final double rating;
  final int avatarColorValue;

  const ExpertModel({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.avatarColorValue,
  });

  factory ExpertModel.fromJson(Map<String, dynamic> json) => ExpertModel(
        id: json['id'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        rating: (json['rating'] as num).toDouble(),
        avatarColorValue: json['avatar_color_value'] as int,
      );

  @override
  List<Object?> get props => [id, name, role, rating, avatarColorValue];
}

class ConsultationTypeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconType;

  const ConsultationTypeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconType,
  });

  factory ConsultationTypeModel.fromJson(Map<String, dynamic> json) =>
      ConsultationTypeModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        iconType: json['icon_type'] as String? ?? 'solar',
      );

  @override
  List<Object?> get props => [id, title, description, iconType];
}

class CalendarDayModel extends Equatable {
  final DateTime date;
  final String dayLabel;
  final bool isCurrentMonth;

  const CalendarDayModel({
    required this.date,
    required this.dayLabel,
    required this.isCurrentMonth,
  });

  factory CalendarDayModel.fromJson(Map<String, dynamic> json) =>
      CalendarDayModel(
        date: DateTime.parse(json['date'] as String),
        dayLabel: json['day_label'] as String,
        isCurrentMonth: json['is_current_month'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [date, dayLabel, isCurrentMonth];
}

class TimeSlotModel extends Equatable {
  final String id;
  final String label;

  const TimeSlotModel({required this.id, required this.label});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
        id: json['id'] as String,
        label: json['label'] as String,
      );

  @override
  List<Object?> get props => [id, label];
}

class ConsultationBookingModel extends Equatable {
  final List<ExpertModel> experts;
  final List<ConsultationTypeModel> types;
  final String monthYearLabel;
  final List<CalendarDayModel> calendarDays;
  final List<TimeSlotModel> timeSlots;
  final String defaultFullName;
  final String defaultPhone;
  final String defaultAddress;
  final String defaultSelectedExpertId;
  final String defaultSelectedTypeId;
  final DateTime defaultSelectedDate;
  final String defaultSelectedTimeSlotId;

  const ConsultationBookingModel({
    required this.experts,
    required this.types,
    required this.monthYearLabel,
    required this.calendarDays,
    required this.timeSlots,
    required this.defaultFullName,
    required this.defaultPhone,
    required this.defaultAddress,
    required this.defaultSelectedExpertId,
    required this.defaultSelectedTypeId,
    required this.defaultSelectedDate,
    required this.defaultSelectedTimeSlotId,
  });

  factory ConsultationBookingModel.fromJson(Map<String, dynamic> json) =>
      ConsultationBookingModel(
        experts: (json['experts'] as List)
            .map((e) => ExpertModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        types: (json['types'] as List)
            .map((e) => ConsultationTypeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        monthYearLabel: json['month_year_label'] as String,
        calendarDays: (json['calendar_days'] as List)
            .map((e) => CalendarDayModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        timeSlots: (json['time_slots'] as List)
            .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        defaultFullName: json['default_full_name'] as String,
        defaultPhone: json['default_phone'] as String,
        defaultAddress: json['default_address'] as String,
        defaultSelectedExpertId: json['default_selected_expert_id'] as String,
        defaultSelectedTypeId: json['default_selected_type_id'] as String,
        defaultSelectedDate:
            DateTime.parse(json['default_selected_date'] as String),
        defaultSelectedTimeSlotId:
            json['default_selected_time_slot_id'] as String,
      );

  @override
  List<Object?> get props => [
        experts,
        types,
        monthYearLabel,
        calendarDays,
        timeSlots,
        defaultFullName,
        defaultPhone,
        defaultAddress,
        defaultSelectedExpertId,
        defaultSelectedTypeId,
        defaultSelectedDate,
        defaultSelectedTimeSlotId,
      ];
}
