import 'package:flutter/material.dart';

enum FavoriteCategoryEnum {
  product('product', Icons.shopping_bag_outlined),
  service('service', Icons.handyman_outlined),
  store('store', Icons.storefront_outlined),
  workshop('workshop', Icons.build_outlined);

  final String name;
  final IconData icon;

  const FavoriteCategoryEnum(this.name, this.icon);
}
