import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/services/data/models/workshop_detail_model.dart';
import 'package:untitled1/features/services/data/models/workshop_service_model.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_screen.dart';

WorkshopInfoData workshopDetailToInfoData(
  WorkshopDetailModel workshop,
  List<WorkshopServiceModel> services, {
  List<DiscountModel> discounts = const [],
}) {
  final businessId = int.tryParse(workshop.id) ?? 0;
  final discountedServices = buildDiscountedWorkshopServices(
    services: services,
    discounts: discounts,
    businessId: businessId,
    imagePlaceholderColorValue: workshop.imagePlaceholderColorValue,
  );
  final mergedServices = mergeWorkshopServicesWithDiscounts(
    services: services,
    discounts: discounts,
    businessId: businessId,
    imagePlaceholderColorValue: workshop.imagePlaceholderColorValue,
  );

  return WorkshopInfoData(
    id: workshop.id,
    name: workshop.name,
    description: workshop.description,
    location: workshop.location,
    phone: workshop.phone,
    region: workshop.region,
    imagePlaceholderColorValue: workshop.imagePlaceholderColorValue,
    logoUrl: workshop.logoUrl,
    coverImageUrl: workshop.coverImageUrl,
    services: mergedServices,
    discountedServices: discountedServices,
  );
}

List<WorkshopServiceItem> buildDiscountedWorkshopServices({
  required List<WorkshopServiceModel> services,
  required List<DiscountModel> discounts,
  required int businessId,
  required int imagePlaceholderColorValue,
}) {
  if (discounts.isEmpty || businessId <= 0) return const [];

  final serviceById = {
    for (final service in services.where((item) => item.isAvailable))
      normalizeProductId(service.id): service,
  };
  final seen = <String>{};
  final items = <WorkshopServiceItem>[];

  for (final candidate in flattenDiscountProducts(discounts)) {
    if (candidate.businessId != businessId) continue;

    final key = normalizeProductId(candidate.productId);
    if (seen.contains(key)) continue;

    final service = serviceById[key];
    if (service == null) continue;

    seen.add(key);
    items.add(
      mergeWorkshopServiceWithCandidate(
        base: workshopServiceToItem(
          service,
          imagePlaceholderColorValue: imagePlaceholderColorValue,
        ),
        candidate: candidate,
        retailPrice: service.price,
      ),
    );
  }

  return items;
}

List<WorkshopServiceItem> mergeWorkshopServicesWithDiscounts({
  required List<WorkshopServiceModel> services,
  required List<DiscountModel> discounts,
  required int businessId,
  required int imagePlaceholderColorValue,
}) {
  final discountedById = {
    for (final item in buildDiscountedWorkshopServices(
      services: services,
      discounts: discounts,
      businessId: businessId,
      imagePlaceholderColorValue: imagePlaceholderColorValue,
    ))
      normalizeProductId(item.id): item,
  };

  return services
      .where((service) => service.isAvailable)
      .map((service) {
        final base = workshopServiceToItem(
          service,
          imagePlaceholderColorValue: imagePlaceholderColorValue,
        );
        final discounted = discountedById[normalizeProductId(service.id)];
        if (discounted != null) return discounted;

        final candidate = findBestDiscountForProduct(
          discounts: discounts,
          businessId: businessId,
          productId: service.id,
        );
        if (candidate == null) return base;

        return mergeWorkshopServiceWithCandidate(
          base: base,
          candidate: candidate,
          retailPrice: service.price,
        );
      })
      .toList();
}

WorkshopServiceItem workshopServiceToItem(
  WorkshopServiceModel service, {
  required int imagePlaceholderColorValue,
}) {
  return WorkshopServiceItem(
    id: service.id,
    name: service.name,
    description:
        service.description.isNotEmpty ? service.description : null,
    price: service.price,
    durationMinutes: service.estimatedDurationMinutes,
    imageUrl: service.imageUrl,
    imagePlaceholderColorValue: imagePlaceholderColorValue,
  );
}

WorkshopServiceItem mergeWorkshopServiceWithCandidate({
  required WorkshopServiceItem base,
  required DiscountProductCandidate candidate,
  required double retailPrice,
}) {
  final pricing = computeDiscountPricing(
    retailPrice: retailPrice,
    discountType: candidate.discountType,
    discountValue: candidate.discountValue,
  );
  if (pricing.discountPercent == null && pricing.salePrice >= retailPrice) {
    return base;
  }

  return WorkshopServiceItem(
    id: base.id,
    name: base.name,
    description: base.description,
    price: pricing.salePrice,
    originalPrice: retailPrice,
    discountPercent: pricing.discountPercent,
    badgeText:
        candidate.discountLabel.isNotEmpty ? candidate.discountLabel : null,
    discountDescription: candidate.description,
    discountStartDate: candidate.startDate,
    discountEndDate: candidate.endDate,
    durationMinutes: base.durationMinutes,
    imageUrl: base.imageUrl,
    imagePlaceholderColorValue: base.imagePlaceholderColorValue,
  );
}

ProductCardData workshopServiceToCardData({
  required WorkshopServiceItem service,
  required int businessId,
}) {
  return ProductCardData(
    id: service.id,
    businessId: businessId,
    name: service.name,
    category: service.durationMinutes > 0
        ? 'services_duration_minutes'.tr(
            namedArgs: {'minutes': '${service.durationMinutes}'},
          )
        : null,
    price: service.price,
    originalPrice: service.originalPrice,
    badgeText: service.badgeText,
    discountPercent: service.discountPercent,
    discountDescription: service.discountDescription,
    discountStartDate: service.discountStartDate,
    discountEndDate: service.discountEndDate,
    imageUrl: service.imageUrl,
    imagePlaceholderColorValue: service.imagePlaceholderColorValue,
    iconType: 'inverter',
  );
}
