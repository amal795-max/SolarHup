import 'package:easy_localization/easy_localization.dart';

/// Formats a discount validity window for compact UI (e.g. product cards).
String formatDiscountPeriod(DateTime? start, DateTime? end) {
  if (start == null && end == null) return '';

  final formatter = DateFormat('MMM d, yyyy');

  if (start != null && end != null) {
    return '${formatter.format(start)} – ${formatter.format(end)}';
  }
  if (end != null) {
    return 'discount_valid_until'.tr(args: [formatter.format(end)]);
  }
  return 'discount_valid_from'.tr(args: [formatter.format(start!)]);
}

bool hasDiscountMeta({
  String? description,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return (description != null && description.trim().isNotEmpty) ||
      startDate != null ||
      endDate != null;
}
