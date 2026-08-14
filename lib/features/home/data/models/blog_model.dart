import 'package:equatable/equatable.dart';

class BlogModel extends Equatable {
  final String id;
  final String title;
  final String meta;
  final int imagePlaceholderColorValue;
  final String? imageUrl;

  /// 'sun' | 'finance'
  final String iconType;

  const BlogModel({
    required this.id,
    required this.title,
    required this.meta,
    required this.imagePlaceholderColorValue,
    this.imageUrl,
    this.iconType = 'sun',
  });

  @override
  List<Object?> get props =>
      [id, title, meta, imagePlaceholderColorValue, imageUrl, iconType];
}
