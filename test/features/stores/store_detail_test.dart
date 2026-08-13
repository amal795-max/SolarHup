import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/stores/data/model/store_list_response_model.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/presentation/mappers/store_info_mapper.dart';

void main() {
  const sampleJson = {
    'id': 42,
    'name': 'SunPeak Energy',
    'description': 'Premium solar hardware solutions.',
    'address': 'Damascus, Syria',
    'phone': '+963912345678',
    'region': 'Damascus',
    'logo': 'https://example.com/logo.png',
    'cover_image': 'https://example.com/cover.png',
    'created_at': '2026-07-30T16:05:07.201Z',
  };

  test('StoreApiModel parses GET /stores/{id} response', () {
    final api = StoreApiModel.fromJson(sampleJson);

    expect(api.id, 42);
    expect(api.name, 'SunPeak Energy');
    expect(api.description, 'Premium solar hardware solutions.');
    expect(api.address, 'Damascus, Syria');
    expect(api.phone, '+963912345678');
    expect(api.region, 'Damascus');
    expect(api.logo, 'https://example.com/logo.png');
    expect(api.coverImage, 'https://example.com/cover.png');
  });

  test('StoreDetailModel maps API data for the detail screen', () {
    final api = StoreApiModel.fromJson(sampleJson);
    final detail = StoreDetailModel.fromApi(api);

    expect(detail.id, '42');
    expect(detail.name, 'SunPeak Energy');
    expect(detail.location, 'Damascus, Syria');
    expect(detail.logoUrl, 'https://example.com/logo.png');
    expect(detail.coverImageUrl, 'https://example.com/cover.png');
  });

  test('storeDetailToInfoData feeds the existing StoreInfo UI', () {
    final api = StoreApiModel.fromJson(sampleJson);
    final ui = storeDetailToInfoData(StoreDetailModel.fromApi(api));

    expect(ui.id, '42');
    expect(ui.name, 'SunPeak Energy');
    expect(ui.description, 'Premium solar hardware solutions.');
    expect(ui.location, 'Damascus, Syria');
    expect(ui.logoUrl, 'https://example.com/logo.png');
    expect(ui.coverImageUrl, 'https://example.com/cover.png');
    expect(ui.rating, 0);
    expect(ui.isVerified, isTrue);
    expect(ui.iconData, isA<IconData>());
    expect(ui.categories, isEmpty);
    expect(ui.featuredProducts, isEmpty);
  });
}
