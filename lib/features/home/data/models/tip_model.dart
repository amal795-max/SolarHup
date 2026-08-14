import 'package:equatable/equatable.dart';

class TipModel extends Equatable {
  final int id;
  final String title;
  final String description;

  const TipModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TipModel.fromJson(Map<String, dynamic> json) {
    return TipModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title, description];
}

List<TipModel> parseTipsResponse(dynamic data, {int maxCount = 3}) {
  final List<dynamic> items;
  if (data is List) {
    items = data;
  } else if (data is Map<String, dynamic>) {
    items = data['tips'] as List<dynamic>? ??
        data['data'] as List<dynamic>? ??
        const [];
  } else {
    items = const [];
  }

  return items
      .whereType<Map<String, dynamic>>()
      .map(TipModel.fromJson)
      .where((tip) => tip.title.isNotEmpty || tip.description.isNotEmpty)
      .take(maxCount)
      .toList(growable: false);
}
