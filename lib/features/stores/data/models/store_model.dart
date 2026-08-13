class StoreModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final List<String> tags;
  final String iconType;
  final int iconColorValue;
  final int imagePlaceholderColorValue;
  final String? logoUrl;
  final String? coverImageUrl;

  const StoreModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.tags,
    required this.iconType,
    required this.iconColorValue,
    required this.imagePlaceholderColorValue,
    this.logoUrl,
    this.coverImageUrl,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String,
        rating: (json['rating'] as num).toDouble(),
        tags: List<String>.from(json['tags'] as List),
        iconType: json['icon_type'] as String? ?? 'lightning',
        iconColorValue: json['icon_color_value'] as int? ?? 0xFF0A2A43,
        imagePlaceholderColorValue:
            json['image_placeholder_color_value'] as int? ?? 0xFF1A3A5C,
        logoUrl: json['logo_url'] as String? ?? json['logo'] as String?,
        coverImageUrl:
            json['cover_image_url'] as String? ?? json['cover_image'] as String?,
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
        'logo_url': logoUrl,
        'cover_image_url': coverImageUrl,
      };
}
