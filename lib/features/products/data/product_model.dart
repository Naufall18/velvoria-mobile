/// Lightweight product model parsed directly from the backend's raw Eloquent
/// JSON (the API does not currently wrap products in a Resource).
class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? comparePrice;
  final int stock;
  final String? imageUrl;
  final String? vendorName;
  final String? brandName;
  final double rating;
  final int totalReviews;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.stock,
    this.description,
    this.comparePrice,
    this.imageUrl,
    this.vendorName,
    this.brandName,
    this.rating = 0,
    this.totalReviews = 0,
  });

  bool get inStock => stock > 0;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    // Image can arrive as `primary_image: {image_url}` (list endpoints) or
    // `images: [{image_url}]` (detail endpoint).
    String? image;
    final primary = json['primary_image'] ?? json['primaryImage'];
    if (primary is Map && primary['image_url'] != null) {
      image = primary['image_url'].toString();
    } else if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      final first = (json['images'] as List).first;
      if (first is Map && first['image_url'] != null) {
        image = first['image_url'].toString();
      }
    }

    String? vendor;
    final v = json['vendor'];
    if (v is Map) {
      vendor = (v['store_name'] ?? v['name'])?.toString();
    }

    String? brand;
    final b = json['brand'];
    if (b is Map) {
      brand = b['name']?.toString();
    }

    return Product(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      description: json['description']?.toString(),
      price: _toDouble(json['price']),
      comparePrice: json['compare_price'] != null ? _toDouble(json['compare_price']) : null,
      stock: _toInt(json['stock']),
      imageUrl: image,
      vendorName: vendor,
      brandName: brand,
      rating: _toDouble(json['rating']),
      totalReviews: _toInt(json['total_reviews']),
    );
  }
}
