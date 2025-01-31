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
      catref: json['_id'] ?? "", // Handle null value
      id: json['category_id'] ?? "1", // Default value for category_id
      name: json['category_name'] ?? "name", // Default value for name
      description:
          json['category_des'] ?? "des", // Default value for description
      imageUrl: json['category_image'] ?? "image", // Default value for imageUrl
      color: json['color'] ?? "FFFFFF", // Default value for color
      visibility: json['visibility'] ?? true, // Handle null visibility
      createdTime: json['created_time'] != null
          ? json['created_time']
          : DateTime.now().toString(), // Handle null createdTime
    );
  }

  // Add the toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': catref,
      'category_id': id,
      'category_name': name,
      'category_des': description,
      'category_image': imageUrl,
      'color': color,
      'visibility': visibility,
      'created_time': createdTime,
    };
  }
}
