import '../../products/data/product_model.dart';

/// A single line item in the user's cart (matches the backend `carts` row,
/// with its related product eager-loaded).
class CartItem {
  final int id;
  final int productId;
  final int? variantId;
  final int quantity;
  final Product product;

  const CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.product,
    this.variantId,
  });

  double get lineTotal => product.price * quantity;

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = (json['product'] as Map<String, dynamic>?) ?? const {};
    return CartItem(
      id: _toInt(json['id']),
      productId: _toInt(json['product_id']),
      variantId: json['product_variant_id'] == null
          ? null
          : _toInt(json['product_variant_id']),
      quantity: _toInt(json['quantity']),
      product: Product.fromJson(productJson),
    );
  }
}
