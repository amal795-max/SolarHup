class WorkshopInfoRouteArgs {
  final String workshopId;
  final int? categoryId;
  final String? highlightServiceId;

  const WorkshopInfoRouteArgs({
    required this.workshopId,
    this.categoryId,
    this.highlightServiceId,
  });
}
