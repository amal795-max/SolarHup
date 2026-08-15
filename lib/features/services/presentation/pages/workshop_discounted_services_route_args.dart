import 'package:untitled1/features/services/presentation/pages/workshop_info_screen.dart';

class WorkshopDiscountedServicesRouteArgs {
  final String workshopId;
  final String workshopName;
  final List<WorkshopServiceItem> services;

  const WorkshopDiscountedServicesRouteArgs({
    required this.workshopId,
    required this.workshopName,
    required this.services,
  });
}
