import 'package:untitled1/core/api/api_response_utils.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';

class DiscountListResponseModel {
  final List<DiscountModel> discounts;

  DiscountListResponseModel({required this.discounts});

  factory DiscountListResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapApiPayload(json);
    final items = payload['discounts'] as List<dynamic>? ??
        json['discounts'] as List<dynamic>? ??
        [];
    return DiscountListResponseModel(
      discounts: items
          .map((item) => DiscountModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
