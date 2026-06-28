/// A user's order as returned by GET /orders (one order = one vendor).
class OrderModel {
  final int id;
  final String orderNumber;
  final String status;
  final double total;
  final int itemCount;
  final String? paymentMethod;
  final String? createdAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.itemCount,
    this.paymentMethod,
    this.createdAt,
  });

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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List?) ?? const [];
    final count = items.fold<int>(
      0,
      (sum, it) => sum + (it is Map ? _toInt(it['quantity']) : 0),
    );

    String? method;
    final payment = json['payment'];
    if (payment is Map) method = payment['payment_method']?.toString();

    return OrderModel(
      id: _toInt(json['id']),
      orderNumber: (json['order_number'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      total: _toDouble(json['total']),
      itemCount: count,
      paymentMethod: method,
      createdAt: json['created_at']?.toString(),
    );
  }
}
