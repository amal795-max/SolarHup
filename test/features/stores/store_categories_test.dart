import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/stores/data/model/store_categories_response_model.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_info_mapper.dart';

void main() {
  const sampleJson = {
    'success': true,
    'data': [
      {'id': 1, 'name': 'Solar Panels', 'type': 'store'},
      {'id': 2, 'name': 'Battery Storage', 'type': 'store'},
      {'id': 3, 'name': 'Inverters', 'type': 'store'},
    ],
    'message': 'Categories retrieved successfully',
  };

  test('StoreCategoriesResponseModel parses GET /categories?type=store', () {
    final categories =
        StoreCategoriesResponseModel.fromJson(sampleJson).toStoreCategoryModels();

    expect(categories, hasLength(3));
    expect(categories.first, const StoreCategoryModel(
      id: 1,
      name: 'Solar Panels',
      type: 'store',
    ));
  });

  test('apiCategoriesToItems shows all API categories even without products', () {
    const categories = [
      StoreCategoryModel(id: 1, name: 'Solar Panels', type: 'store'),
      StoreCategoryModel(id: 5, name: 'Wind Turbines', type: 'store'),
    ];

    final items = apiCategoriesToItems(categories);

    expect(items, hasLength(2));
    expect(items.last.label, 'Wind Turbines');
    expect(items.last.categoryId, 5);
  });
}
