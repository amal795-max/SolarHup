import 'package:equatable/equatable.dart';

class ProductCoreSpecs extends Equatable {
  final String maxPowerOutput;
  final String efficiency;
  final String warranty;
  final String brand;
  final String cellTechnology;

  const ProductCoreSpecs({
    required this.maxPowerOutput,
    required this.efficiency,
    required this.warranty,
    required this.brand,
    required this.cellTechnology,
  });

  factory ProductCoreSpecs.fromJson(Map<String, dynamic> json) =>
      ProductCoreSpecs(
        maxPowerOutput: json['max_power_output'] as String,
        efficiency: json['efficiency'] as String,
        warranty: json['warranty'] as String,
        brand: json['brand'] as String,
        cellTechnology: json['cell_technology'] as String,
      );

  @override
  List<Object?> get props =>
      [maxPowerOutput, efficiency, warranty, brand, cellTechnology];
}

class ProductTechnicalData extends Equatable {
  final String weight;
  final String dimensions;
  final String connectors;
  final String maxSystemVoltage;
  final String operatingTemp;
  final String material;
  final String outputType;

  const ProductTechnicalData({
    required this.weight,
    required this.dimensions,
    required this.connectors,
    required this.maxSystemVoltage,
    required this.operatingTemp,
    required this.material,
    required this.outputType,
  });

  factory ProductTechnicalData.fromJson(Map<String, dynamic> json) =>
      ProductTechnicalData(
        weight: json['weight'] as String,
        dimensions: json['dimensions'] as String,
        connectors: json['connectors'] as String,
        maxSystemVoltage: json['max_system_voltage'] as String,
        operatingTemp: json['operating_temp'] as String,
        material: json['material'] as String,
        outputType: json['output_type'] as String,
      );

  @override
  List<Object?> get props => [
        weight,
        dimensions,
        connectors,
        maxSystemVoltage,
        operatingTemp,
        material,
        outputType,
      ];
}

class ProductReviewModel extends Equatable {
  final String id;
  final String userName;
  final String userInitials;
  final bool isVerifiedBuyer;
  final String dateAgo;
  final double rating;
  final String body;

  const ProductReviewModel({
    required this.id,
    required this.userName,
    required this.userInitials,
    required this.isVerifiedBuyer,
    required this.dateAgo,
    required this.rating,
    required this.body,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      ProductReviewModel(
        id: json['id'] as String,
        userName: json['user_name'] as String,
        userInitials: json['user_initials'] as String,
        isVerifiedBuyer: json['is_verified_buyer'] as bool? ?? false,
        dateAgo: json['date_ago'] as String,
        rating: (json['rating'] as num).toDouble(),
        body: json['body'] as String,
      );

  @override
  List<Object?> get props =>
      [id, userName, userInitials, isVerifiedBuyer, dateAgo, rating, body];
}

class ProductDetailModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final double currentPrice;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final bool isBestseller;
  final List<int> imagePlaceholderColors;
  final ProductCoreSpecs coreSpecs;
  final ProductTechnicalData technicalData;
  final List<ProductReviewModel> reviews;

  const ProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.currentPrice,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.isBestseller,
    required this.imagePlaceholderColors,
    required this.coreSpecs,
    required this.technicalData,
    required this.reviews,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        currentPrice: (json['current_price'] as num).toDouble(),
        originalPrice: json['original_price'] != null
            ? (json['original_price'] as num).toDouble()
            : null,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['review_count'] as int,
        isBestseller: json['is_bestseller'] as bool? ?? false,
        imagePlaceholderColors: List<int>.from(
          (json['image_placeholder_colors'] as List).map((e) => e as int),
        ),
        coreSpecs: ProductCoreSpecs.fromJson(
          json['core_specs'] as Map<String, dynamic>,
        ),
        technicalData: ProductTechnicalData.fromJson(
          json['technical_data'] as Map<String, dynamic>,
        ),
        reviews: (json['reviews'] as List)
            .map((e) => ProductReviewModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        currentPrice,
        originalPrice,
        rating,
        reviewCount,
        isBestseller,
        imagePlaceholderColors,
        coreSpecs,
        technicalData,
        reviews,
      ];
}
