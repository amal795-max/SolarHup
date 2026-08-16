import 'package:equatable/equatable.dart';

class HomeLayoutModel extends Equatable {
  final String key;
  final int order;
  final bool isActive;

  const HomeLayoutModel({
    required this.key,
    required this.order,
    required this.isActive,
  });

  factory HomeLayoutModel.fromJson(Map<String, dynamic> json) {
    return HomeLayoutModel(
      key: json['key'] as String,
      order: json['order'] as int,
      isActive: json['is_active'] as bool,
    );
  }

  static const List<HomeLayoutModel> defaultLayout = [
    HomeLayoutModel(key: 'promotions', order: 1, isActive: true),
    HomeLayoutModel(key: 'tips', order: 2, isActive: true),
    HomeLayoutModel(key: 'best_sellers', order: 3, isActive: true),
    HomeLayoutModel(key: 'blog_highlights', order: 4, isActive: true),
    HomeLayoutModel(key: 'used_systems', order: 5, isActive: true),
  ];

  @override
  List<Object?> get props => [key, order, isActive];
}
