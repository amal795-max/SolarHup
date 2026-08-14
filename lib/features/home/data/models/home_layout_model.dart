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

  @override
  List<Object?> get props => [key, order, isActive];
}
