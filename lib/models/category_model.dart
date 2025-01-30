class Category {
  final String catref;
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String color;
  final bool? visibility; // Optional field
  final String? createdTime; // Optional field

  Category({
    required this.catref,
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.color,
    this.visibility,
    this.createdTime,
  });

  // Factory method to create a category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catref: json['_id'],
      id: json['category_id'] ?? "1",
      name: json['category_name'] ?? "name",
      description: json['category_des'] ?? "des",
      imageUrl: json['category_image'] ?? "image",
      color: json['color'] ?? "FFFFFF",
      visibility: json['visibility'] ?? true, // optional field
      createdTime: json['created_time'], // optional field
    );
  }
}
