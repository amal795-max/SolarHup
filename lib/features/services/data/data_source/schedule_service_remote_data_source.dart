import '../models/schedule_service_model.dart';

abstract class ScheduleServiceRemoteDataSource {
  Future<ScheduleServiceModel> getScheduleService(String serviceId);
}

class ScheduleServiceRemoteDataSourceImpl
    implements ScheduleServiceRemoteDataSource {
  const ScheduleServiceRemoteDataSourceImpl();

  static const _defaultTimeSlots = [
    ServiceTimeSlotModel(id: '09-00', label: '09:00 AM', iconType: 'sunny'),
    ServiceTimeSlotModel(id: '11-00', label: '11:00 AM', iconType: 'sunny'),
    ServiceTimeSlotModel(id: '14-00', label: '02:00 PM', iconType: 'sunny'),
    ServiceTimeSlotModel(
      id: '16-30',
      label: '04:30 PM',
      iconType: 'cloudy',
    ),
  ];

  static final _services = <String, ScheduleServiceModel>{
    'svc-1': ScheduleServiceModel(
      serviceId: 'svc-1',
      title: 'Maintenance Check',
      subtitle: 'Expert solar panel optimization',
      heroColorValue: 0xFF1A3A5C,
      appointmentSummaryTitle: 'Full Panel Service',
      timeSlots: _defaultTimeSlots,
      defaultSelectedDate: DateTime(2024, 10, 10),
      defaultSelectedTimeSlotId: '11-00',
      calendarYear: 2024,
      calendarMonth: 10,
    ),
    'svc-2': ScheduleServiceModel(
      serviceId: 'svc-2',
      title: 'Emergency Inverter Repair',
      subtitle: 'On-site inverter diagnostics and repair',
      heroColorValue: 0xFF2A4A6C,
      appointmentSummaryTitle: 'Inverter Repair Visit',
      timeSlots: _defaultTimeSlots,
      defaultSelectedDate: DateTime(2024, 10, 10),
      defaultSelectedTimeSlotId: '11-00',
      calendarYear: 2024,
      calendarMonth: 10,
    ),
    'svc-featured-1': ScheduleServiceModel(
      serviceId: 'svc-featured-1',
      title: 'Premium Installation Kit',
      subtitle: 'Full system deployment consultation',
      heroColorValue: 0xFF0A2A43,
      appointmentSummaryTitle: 'Installation Planning Session',
      timeSlots: _defaultTimeSlots,
      defaultSelectedDate: DateTime(2024, 10, 10),
      defaultSelectedTimeSlotId: '11-00',
      calendarYear: 2024,
      calendarMonth: 10,
    ),
  };

  static ScheduleServiceModel _buildFallback(String serviceId) {
    final now = DateTime.now();
    return ScheduleServiceModel(
      serviceId: serviceId,
      title: 'Service Booking',
      subtitle: 'Choose your preferred date and time',
      heroColorValue: 0xFF1A3A5C,
      appointmentSummaryTitle: 'Service Visit',
      timeSlots: _defaultTimeSlots,
      defaultSelectedDate: now,
      defaultSelectedTimeSlotId: '11-00',
      calendarYear: now.year,
      calendarMonth: now.month,
    );
  }

  @override
  Future<ScheduleServiceModel> getScheduleService(String serviceId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _services[serviceId] ?? _buildFallback(serviceId);
  }
}
