/// A top-level catalog category as returned by GET /categories.
class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.productCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;
    return CategoryModel(
      id: toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      image: json['image']?.toString(),
      productCount: toInt(json['products_count']),
    );
  }
}
