import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import 'order_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(apiClientProvider));
});

/// The authenticated user's orders, newest first.
final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final raw = await ref.watch(orderRepositoryProvider).fetchOrders();
  return raw
      .whereType<Map<String, dynamic>>()
      .map(OrderModel.fromJson)
      .toList();
});

class OrderRepository {
  final ApiClient _api;

  OrderRepository(this._api);

  /// Create order(s) from the current cart. [paymentMethod] is 'cod' or
  /// 'midtrans'. Returns the raw list of created orders.
  Future<List<dynamic>> createOrder({
    required String paymentMethod,
    required String shippingName,
    required String shippingPhone,
    required String shippingAddress,
    required String shippingCity,
    required String shippingProvince,
    required String shippingPostalCode,
    String? notes,
  }) async {
    try {
      final res = await _api.post('/orders', data: {
        'payment_method': paymentMethod,
        'shipping_name': shippingName,
        'shipping_phone': shippingPhone,
        'shipping_address': shippingAddress,
        'shipping_city': shippingCity,
        'shipping_province': shippingProvince,
        'shipping_postal_code': shippingPostalCode,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });
      return (res.data['orders'] as List?) ?? const [];
    } on DioException catch (e) {
      Logger.error('createOrder failed', tag: 'OrderRepo', error: e);
      rethrow;
    }
  }

  /// GET /orders → list of the user's orders.
  Future<List<dynamic>> fetchOrders() async {
    final res = await _api.get('/orders');
    return (res.data['orders'] as List?) ?? const [];
  }
}
