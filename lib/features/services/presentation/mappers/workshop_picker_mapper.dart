import 'package:untitled1/features/services/data/models/workshop_offering_model.dart';

class WorkshopPickerGroup {
  final String workshopId;
  final String workshopName;
  final String location;
  final String? logoUrl;
  final String? coverImageUrl;
  final int iconColorValue;
  final double startingPrice;
  final String highlightServiceId;
  final int serviceCount;

  const WorkshopPickerGroup({
    required this.workshopId,
    required this.workshopName,
    required this.location,
    this.logoUrl,
    this.coverImageUrl,
    required this.iconColorValue,
    required this.startingPrice,
    required this.highlightServiceId,
    required this.serviceCount,
  });
}

List<WorkshopPickerGroup> groupOfferingsByWorkshop(
  List<WorkshopOfferingModel> offerings,
) {
  final grouped = <String, List<WorkshopOfferingModel>>{};
  for (final offering in offerings) {
    grouped.putIfAbsent(offering.workshopId, () => []).add(offering);
  }

  final results = grouped.entries.map((entry) {
    final items = entry.value..sort((a, b) => a.price.compareTo(b.price));
    final cheapest = items.first;
    return WorkshopPickerGroup(
      workshopId: cheapest.workshopId,
      workshopName: cheapest.workshopName,
      location: cheapest.location,
      logoUrl: cheapest.logoUrl,
      coverImageUrl: cheapest.coverImageUrl,
      iconColorValue: cheapest.iconColorValue,
      startingPrice: cheapest.price,
      highlightServiceId: cheapest.serviceId,
      serviceCount: items.length,
    );
  }).toList();

  results.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
  return results;
}
