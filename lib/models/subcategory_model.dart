class SubCategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String createdTime;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdTime,
  });

  // Factory method to create a SubCategoryModel from JSON
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['sub_category_id'] ?? '',
      name: json['sub_category_name'] ?? '',
      description: json['sub_category_des'] ?? '',
      imageUrl: json['sub_category_image'] ?? '',
      createdTime: json['sub_created_time'] ?? '',
    );
  }

  // Method to convert SubCategoryModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'sub_category_id': id,
      'sub_category_name': name,
      'sub_category_des': description,
      'sub_category_image': imageUrl,
      'sub_created_time': createdTime,
    };
  }
}
