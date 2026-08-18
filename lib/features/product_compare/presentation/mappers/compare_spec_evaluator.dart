import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';

/// Keys excluded from compare — unique, vendor-specific, or not a performance metric.
const compareExcludedSpecKeys = <String>{
  'brand',
  'product_detail_sku',
  'product_detail_country_of_origin',
  'product_detail_compatibility',
  'product_detail_stock',
  'product_detail_voltage',
  'product_detail_battery_type',
  'product_detail_inverter_type',
  'product_detail_cell_technology',
  'product_detail_frame_type',
  'product_detail_glass_type',
  'product_detail_wave_type',
  'product_detail_bms_features',
  'product_detail_case_material_ip',
  'product_detail_protections',
  'product_detail_communication_ports',
  'product_detail_mppt_range',
  'product_detail_operating_temp',
  'product_detail_supported_battery_voltage',
  'product_detail_output_voltage',
  'product_detail_dimensions',
};

enum CompareMetricDirection { higherBetter, lowerBetter }

/// How each spec is scored when both values are numeric.
const compareMetricDirections = <String, CompareMetricDirection>{
  // Solar panel — higher output & efficiency wins
  'product_detail_max_power_output': CompareMetricDirection.higherBetter,
  'product_detail_efficiency': CompareMetricDirection.higherBetter,
  'product_detail_vmp': CompareMetricDirection.higherBetter,
  'product_detail_imp': CompareMetricDirection.higherBetter,
  'product_detail_voc': CompareMetricDirection.higherBetter,
  'product_detail_isc': CompareMetricDirection.higherBetter,
  'product_detail_number_of_cells': CompareMetricDirection.higherBetter,
  // Battery — more capacity, cycles, current & usable DOD wins; less weight wins
  'product_detail_capacity': CompareMetricDirection.higherBetter,
  'product_detail_cycle_life': CompareMetricDirection.higherBetter,
  'product_detail_max_charge_current': CompareMetricDirection.higherBetter,
  'product_detail_max_discharge_current': CompareMetricDirection.higherBetter,
  'product_detail_depth_of_discharge': CompareMetricDirection.higherBetter,
  'product_detail_weight': CompareMetricDirection.lowerBetter,
  // Inverter — more power, efficiency & MPPT channels wins
  'product_detail_power_rating': CompareMetricDirection.higherBetter,
  'product_detail_conversion_efficiency': CompareMetricDirection.higherBetter,
  'product_detail_number_of_mppts': CompareMetricDirection.higherBetter,
  // Shared — longer warranty wins
  'product_detail_warranty': CompareMetricDirection.higherBetter,
};

CompareMetricDirection? compareDirectionForKey(String labelKey) =>
    compareMetricDirections[labelKey];

bool isCompareExcludedSpec(String labelKey) =>
    compareExcludedSpecKeys.contains(labelKey);

bool isComparableSpecKey(String labelKey) =>
    !isCompareExcludedSpec(labelKey) &&
    compareDirectionForKey(labelKey) != null;

/// Parses the first number from values like `21%`, `500 W`, `5 yrs`, `20 kg`.
double? parseComparableNumber(String? raw) {
  if (raw == null || raw.trim().isEmpty || raw.trim() == '—') return null;

  final normalized = raw
      .replaceAll(',', '')
      .replaceAll(RegExp(r'[^\d.\-eE+]'), ' ')
      .trim();

  if (normalized.isEmpty) return null;

  final match =
      RegExp(r'-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?').firstMatch(normalized);
  if (match == null) return null;

  return double.tryParse(match.group(0)!);
}

CompareSpecWinner evaluateSpecWinner({
  required String labelKey,
  required String? leftValue,
  required String? rightValue,
}) {
  final direction = compareDirectionForKey(labelKey);
  if (direction == null) return CompareSpecWinner.none;

  final left = parseComparableNumber(leftValue);
  final right = parseComparableNumber(rightValue);

  if (left == null && right == null) return CompareSpecWinner.none;
  if (left != null && right == null) return CompareSpecWinner.left;
  if (left == null && right != null) return CompareSpecWinner.right;

  const epsilon = 0.0001;
  if ((left! - right!).abs() <= epsilon) return CompareSpecWinner.tie;

  final leftWins = switch (direction) {
    CompareMetricDirection.higherBetter => left > right,
    CompareMetricDirection.lowerBetter => left < right,
  };

  return leftWins ? CompareSpecWinner.left : CompareSpecWinner.right;
}

CompareSpecWinner evaluatePriceWinner({
  required double? leftPrice,
  required double? rightPrice,
}) {
  if (leftPrice == null && rightPrice == null) return CompareSpecWinner.none;
  if (leftPrice != null && rightPrice == null) return CompareSpecWinner.left;
  if (leftPrice == null && rightPrice != null) return CompareSpecWinner.right;

  const epsilon = 0.009;
  if ((leftPrice! - rightPrice!).abs() <= epsilon) return CompareSpecWinner.tie;

  return leftPrice < rightPrice ? CompareSpecWinner.left : CompareSpecWinner.right;
}
