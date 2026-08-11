import 'package:flutter/material.dart';
import 'package:untitled1/core/api/api_response_utils.dart';
import '../models/product_detail_model.dart';
import '../models/store_product_model.dart';

class StoreProductApiModel {
  final int id;
  final int businessId;
  final int categoryId;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final String category;
  final String brand;
  final List<String> images;
  final bool isAvailable;
  final int? warrantyYears;
  final String? sku;
  final double? weightKg;
  final String? dimensionsMm;
  final String? countryOfOrigin;
  final String? compatibilityNotes;
  final Map<String, dynamic>? specs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StoreProductApiModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.brand,
    required this.images,
    required this.isAvailable,
    this.warrantyYears,
    this.sku,
    this.weightKg,
    this.dimensionsMm,
    this.countryOfOrigin,
    this.compatibilityNotes,
    this.specs,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreProductApiModel.fromJson(Map<String, dynamic> json) {
    final imageItems = json['images'] as List<dynamic>? ?? [];
    final specsRaw = json['specs'];
    return StoreProductApiModel(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['retail_price'] ?? json['price'])?.toString() ?? '0',
      quantity: json['stock_quantity'] as int? ?? json['quantity'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      images: imageItems.map((item) => item.toString()).toList(),
      isAvailable: json['is_available'] as bool? ?? true,
      warrantyYears: json['warranty_years'] as int?,
      sku: json['sku'] as String?,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      dimensionsMm: json['dimensions_mm'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      compatibilityNotes: json['compatibility_notes'] as String?,
      specs: specsRaw is Map<String, dynamic> ? specsRaw : null,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  StoreProductModel toStoreProductModel() {
    return StoreProductModel(
      id: id.toString(),
      businessId: businessId.toString(),
      categoryId: categoryId,
      name: name,
      description: description,
      price: _parsePrice(price),
      quantity: quantity,
      category: category,
      brand: brand,
      imageUrl: images.isNotEmpty ? images.first : null,
      isAvailable: isAvailable,
      imagePlaceholderColorValue: _placeholderColor(id),
    );
  }

  ProductDetailModel toProductDetailModel() {
    return ProductDetailModel(
      id: id,
      title: name,
      description: description,
      currentPrice: _parsePrice(price),
      imageUrls: images,
      imagePlaceholderColorValue: _placeholderColor(id),
      isAvailable: isAvailable,
      stockQuantity: quantity,
      category: category,
      highlightSpecs: _buildHighlightSpecs(),
      technicalRows: _buildTechnicalRows(),
    );
  }

  List<ProductSpecHighlight> _buildHighlightSpecs() {
    return switch (category) {
      'solar_panel' => _solarPanelHighlights(),
      'battery' => _batteryHighlights(),
      'inverter' => _inverterHighlights(),
      _ => _genericHighlights(),
    };
  }

  List<ProductSpecHighlight> _solarPanelHighlights() {
    final panel = _categorySpecs();
    final highlights = <ProductSpecHighlight>[];

    void add(
      String labelKey,
      String? value, {
      IconData? icon,
      bool fullWidth = false,
    }) {
      if (value != null && value.trim().isNotEmpty) {
        highlights.add(
          ProductSpecHighlight(
            labelKey: labelKey,
            value: value,
            icon: icon,
            fullWidth: fullWidth,
          ),
        );
      }
    }

    add(
      'product_detail_max_power_output',
      _readSpec(panel, 'nominal_power_w', suffix: ' W'),
      icon: Icons.bolt_rounded,
      fullWidth: true,
    );
    add('product_detail_efficiency', _readSpec(panel, 'efficiency_pct', suffix: '%'));
    add('product_detail_warranty', _warrantyLabel());
    add('brand', brand.isNotEmpty ? brand : null);
    add('product_detail_cell_technology', panel?['cell_type']?.toString());

    return highlights;
  }

  List<ProductSpecHighlight> _batteryHighlights() {
    final battery = _categorySpecs();
    final highlights = <ProductSpecHighlight>[];

    void add(
      String labelKey,
      String? value, {
      IconData? icon,
      bool fullWidth = false,
    }) {
      if (value != null && value.trim().isNotEmpty) {
        highlights.add(
          ProductSpecHighlight(
            labelKey: labelKey,
            value: value,
            icon: icon,
            fullWidth: fullWidth,
          ),
        );
      }
    }

    add(
      'product_detail_capacity',
      battery?['capacity_ah_wh']?.toString(),
      icon: Icons.battery_charging_full_rounded,
      fullWidth: true,
    );
    add('product_detail_voltage', battery?['voltage_v']?.toString());
    add('product_detail_battery_type', battery?['battery_type']?.toString());
    add('product_detail_warranty', _warrantyLabel());
    add('brand', brand.isNotEmpty ? brand : null);

    return highlights;
  }

  List<ProductSpecHighlight> _inverterHighlights() {
    final inverter = _categorySpecs();
    final highlights = <ProductSpecHighlight>[];

    void add(
      String labelKey,
      String? value, {
      IconData? icon,
      bool fullWidth = false,
    }) {
      if (value != null && value.trim().isNotEmpty) {
        highlights.add(
          ProductSpecHighlight(
            labelKey: labelKey,
            value: value,
            icon: icon,
            fullWidth: fullWidth,
          ),
        );
      }
    }

    add(
      'product_detail_power_rating',
      _readSpec(inverter, 'power_rating_kw', suffix: ' kW'),
      icon: Icons.electrical_services_rounded,
      fullWidth: true,
    );
    add('product_detail_inverter_type', inverter?['inverter_type']?.toString());
    add(
      'product_detail_conversion_efficiency',
      _readSpec(inverter, 'conversion_efficiency_pct', suffix: '%'),
    );
    add('product_detail_warranty', _warrantyLabel());
    add('brand', brand.isNotEmpty ? brand : null);

    return highlights;
  }

  List<ProductSpecHighlight> _genericHighlights() {
    final highlights = <ProductSpecHighlight>[];
    if (brand.isNotEmpty) {
      highlights.add(ProductSpecHighlight(labelKey: 'brand', value: brand));
    }
    final warranty = _warrantyLabel();
    if (warranty != null) {
      highlights.add(
        ProductSpecHighlight(labelKey: 'product_detail_warranty', value: warranty),
      );
    }
    return highlights;
  }

  List<ProductDetailDataRow> _buildTechnicalRows() {
    return switch (category) {
      'solar_panel' => _solarPanelTechnicalRows(),
      'battery' => _batteryTechnicalRows(),
      'inverter' => _inverterTechnicalRows(),
      _ => _commonTechnicalRows(),
    };
  }

  List<ProductDetailDataRow> _solarPanelTechnicalRows() {
    final panel = _categorySpecs();
    final rows = <ProductDetailDataRow>[];

    void add(String labelKey, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        rows.add(ProductDetailDataRow(labelKey: labelKey, value: value));
      }
    }

    add('product_detail_vmp', _readSpec(panel, 'vmp_v', suffix: ' V'));
    add('product_detail_imp', _readSpec(panel, 'imp_a', suffix: ' A'));
    add('product_detail_voc', _readSpec(panel, 'voc_v', suffix: ' V'));
    add('product_detail_isc', _readSpec(panel, 'isc_a', suffix: ' A'));
    add('product_detail_number_of_cells', panel?['number_of_cells']?.toString());
    add('product_detail_frame_type', panel?['frame_type']?.toString());
    add('product_detail_glass_type', panel?['glass_type']?.toString());
    rows.addAll(_commonTechnicalRows());

    return rows;
  }

  List<ProductDetailDataRow> _batteryTechnicalRows() {
    final battery = _categorySpecs();
    final rows = <ProductDetailDataRow>[];

    void add(String labelKey, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        rows.add(ProductDetailDataRow(labelKey: labelKey, value: value));
      }
    }

    add('product_detail_cycle_life', battery?['cycle_life']?.toString());
    add(
      'product_detail_depth_of_discharge',
      _readSpec(battery, 'depth_of_discharge_pct', suffix: '%'),
    );
    add(
      'product_detail_max_charge_current',
      _readSpec(battery, 'max_charge_current_a', suffix: ' A'),
    );
    add(
      'product_detail_max_discharge_current',
      _readSpec(battery, 'max_discharge_current_a', suffix: ' A'),
    );
    add('product_detail_operating_temp', battery?['operating_temp']?.toString());
    add('product_detail_bms_features', battery?['bms_features']?.toString());
    add('product_detail_case_material_ip', battery?['case_material_ip']?.toString());
    rows.addAll(_commonTechnicalRows());

    return rows;
  }

  List<ProductDetailDataRow> _inverterTechnicalRows() {
    final inverter = _categorySpecs();
    final rows = <ProductDetailDataRow>[];

    void add(String labelKey, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        rows.add(ProductDetailDataRow(labelKey: labelKey, value: value));
      }
    }

    add(
      'product_detail_supported_battery_voltage',
      _readSpec(inverter, 'supported_battery_voltage_v', suffix: ' V'),
    );
    add(
      'product_detail_output_voltage',
      _readSpec(inverter, 'output_voltage_v', suffix: ' V'),
    );
    add('product_detail_wave_type', inverter?['wave_type']?.toString());
    add('product_detail_mppt_range', inverter?['mppt_range']?.toString());
    add(
      'product_detail_number_of_mppts',
      inverter?['number_of_mppts']?.toString(),
    );
    add(
      'product_detail_communication_ports',
      inverter?['communication_ports']?.toString(),
    );
    add('product_detail_protections', inverter?['protections']?.toString());
    rows.addAll(_commonTechnicalRows());

    return rows;
  }

  List<ProductDetailDataRow> _commonTechnicalRows() {
    final rows = <ProductDetailDataRow>[];

    void add(String labelKey, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        rows.add(ProductDetailDataRow(labelKey: labelKey, value: value));
      }
    }

    if (weightKg != null) {
      add('product_detail_weight', '${weightKg!.toStringAsFixed(1)} kg');
    }
    add('product_detail_dimensions', dimensionsMm);
    add('product_detail_sku', sku);
    add('product_detail_country_of_origin', countryOfOrigin);
    add('product_detail_compatibility', compatibilityNotes);
    if (quantity > 0) {
      add('product_detail_stock', '$quantity units');
    }

    return rows;
  }

  Map<String, dynamic>? _categorySpecs() {
    if (specs == null || specs!.isEmpty) return null;
    final nested = specs![category];
    if (nested is Map<String, dynamic>) return nested;
    return null;
  }

  String? _warrantyLabel() =>
      warrantyYears != null ? '$warrantyYears yrs' : null;

  String? _readSpec(
    Map<String, dynamic>? categorySpecs,
    String key, {
    String suffix = '',
  }) {
    if (categorySpecs == null) return null;
    final value = categorySpecs[key];
    if (value == null) return null;
    return '$value$suffix';
  }
}

class StoreProductsResponseModel {
  final List<StoreProductApiModel> products;

  StoreProductsResponseModel({required this.products});

  factory StoreProductsResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapApiPayload(json);
    final items = payload['products'] as List<dynamic>? ?? [];
    return StoreProductsResponseModel(
      products: items
          .map(
            (item) =>
                StoreProductApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  List<StoreProductModel> toStoreProductModels() {
    return products.map((product) => product.toStoreProductModel()).toList();
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

double _parsePrice(String raw) {
  final normalized = raw.replaceAll('+', '').trim();
  return double.tryParse(normalized) ?? 0;
}

int _placeholderColor(int id) {
  const palette = [
    0xFF1A3A5C,
    0xFF2D2D2D,
    0xFF1C3A2E,
    0xFF0A2A43,
    0xFF8B6200,
    0xFF1A5C2A,
    0xFF0D2137,
  ];
  return palette[id.abs() % palette.length];
}
