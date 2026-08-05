import 'package:equatable/equatable.dart';

class StoreCategoryModel extends Equatable {
  final int id;
  final String name;
  final String type;

  const StoreCategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}
