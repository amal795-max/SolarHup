class StoreModel {
  final int id;
  final String name;
  final String location;
  final double rating;
  final List<String> tags;
  final String iconType;
  final int iconColorValue;
  final int imagePlaceholderColorValue;
  final String? imageUrl;

  const StoreModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.tags,
    required this.iconType,
    required this.iconColorValue,
    required this.imagePlaceholderColorValue,
    this.imageUrl,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        id: json['id'] ,
        name: json['name'] as String,
        location: json['location'] as String,
        rating: (json['rating'] as num).toDouble(),
        tags: List<String>.from(json['tags'] as List),
        iconType: json['icon_type'] as String? ?? 'lightning',
        iconColorValue: json['icon_color_value'] as int? ?? 0xFF0A2A43,
        imagePlaceholderColorValue:
            json['image_placeholder_color_value'] as int? ?? 0xFF1A3A5C,
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'rating': rating,
        'tags': tags,
        'icon_type': iconType,
        'icon_color_value': iconColorValue,
        'image_placeholder_color_value': imagePlaceholderColorValue,
        'image_url': imageUrl,
      };
}
