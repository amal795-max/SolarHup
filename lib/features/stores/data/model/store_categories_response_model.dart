import '../models/store_category_model.dart';

class StoreCategoryApiModel {
  final int id;
  final String name;
  final String type;

  StoreCategoryApiModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory StoreCategoryApiModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryApiModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  StoreCategoryModel toStoreCategoryModel() {
    return StoreCategoryModel(id: id, name: name, type: type);
  }
}

class StoreCategoriesResponseModel {
  final List<StoreCategoryApiModel> categories;

  StoreCategoriesResponseModel({required this.categories});

  factory StoreCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final items = data is List<dynamic>
        ? data
        : json['categories'] as List<dynamic>? ?? [];
    return StoreCategoriesResponseModel(
      categories: items
          .map(
            (item) =>
                StoreCategoryApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  List<StoreCategoryModel> toStoreCategoryModels() {
    return categories.map((item) => item.toStoreCategoryModel()).toList();
  }
}
