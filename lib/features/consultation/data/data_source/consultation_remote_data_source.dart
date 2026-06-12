import 'package:untitled1/features/consultation/data/models/consultation_booking_model.dart';

abstract class ConsultationRemoteDataSource {
  Future<ConsultationBookingModel> getBookingData({int weekOffset = 0});
}

class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  const ConsultationRemoteDataSourceImpl();

  static const _baseWeekStart = '2023-10-25';

  @override
  Future<ConsultationBookingModel> getBookingData({int weekOffset = 0}) async {
    // TODO: Replace with real API call via Dio
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final weekStart = DateTime.parse(_baseWeekStart).add(Duration(days: weekOffset * 7));
    final monthYearLabel = _formatMonthYear(weekStart.add(const Duration(days: 3)));

    return ConsultationBookingModel(
      experts: const [
        ExpertModel(
          id: 'david-chen',
          name: 'David Chen',
          role: 'Design Specialist',
          rating: 4.9,
          avatarColorValue: 0xFF2D5C86,
        ),
        ExpertModel(
          id: 'sarah-miller',
          name: 'Sarah Miller',
          role: 'System Auditor',
          rating: 4.8,
          avatarColorValue: 0xFF8798A6,
        ),
      ],
      types: const [
        ConsultationTypeModel(
          id: 'system-recommendation',
          title: 'System Recommendation',
          description: 'Find the best setup for your home',
          iconType: 'solar',
        ),
        ConsultationTypeModel(
          id: 'product-review',
          title: 'Product Review',
          description: 'Deep dive into specific hardware',
          iconType: 'box',
        ),
        ConsultationTypeModel(
          id: 'design-review',
          title: 'Design Review',
          description: 'Audit your existing solar blueprints',
          iconType: 'compass',
        ),
      ],
      monthYearLabel: monthYearLabel,
      calendarDays: _buildCalendarDays(weekStart),
      timeSlots: const [
        TimeSlotModel(id: '09-00', label: '09:00 AM'),
        TimeSlotModel(id: '10-30', label: '10:30 AM'),
        TimeSlotModel(id: '13-00', label: '01:00 PM'),
        TimeSlotModel(id: '14-30', label: '02:30 PM'),
        TimeSlotModel(id: '16-00', label: '04:00 PM'),
      ],
      defaultFullName: 'Alex Henderson',
      defaultPhone: '+1 (555) 0123-456',
      defaultAddress: '123 Solar Way, Sunnyvale, CA',
      defaultSelectedExpertId: 'david-chen',
      defaultSelectedTypeId: 'system-recommendation',
      defaultSelectedDate: DateTime(2023, 10, 3),
      defaultSelectedTimeSlotId: '10-30',
    );
  }

  List<CalendarDayModel> _buildCalendarDays(DateTime weekStart) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      return CalendarDayModel(
        date: date,
        dayLabel: labels[index],
        isCurrentMonth: date.month == 10,
      );
    });
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
