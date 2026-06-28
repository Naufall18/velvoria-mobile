import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import '../data/cart_model.dart';

/// Holds the cart line items and exposes mutating actions backed by the API.
class CartController extends AsyncNotifier<List<CartItem>> {
  ApiClient get _api => ref.read(apiClientProvider);

  @override
  Future<List<CartItem>> build() => _fetch();

  Future<List<CartItem>> _fetch() async {
    final res = await _api.get('/cart');
    final items = (res.data['data']?['items'] as List?) ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(CartItem.fromJson)
        .toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> add({
    required int productId,
    int quantity = 1,
    int? variantId,
  }) async {
    try {
      await _api.post('/cart', data: {
        'product_id': productId,
        'quantity': quantity,
        if (variantId != null) 'product_variant_id': variantId,
      });
      await refresh();
    } on DioException catch (e) {
      Logger.error('add to cart failed', tag: 'CartController', error: e);
      rethrow;
    }
  }

  Future<void> updateQuantity(int cartId, int quantity) async {
    if (quantity < 1) return;
    await _api.put('/cart/$cartId', data: {'quantity': quantity});
    await refresh();
  }

  Future<void> remove(int cartId) async {
    await _api.delete('/cart/$cartId');
    await refresh();
  }

  Future<void> clear() async {
    await _api.delete('/cart');
    await refresh();
  }
}

final cartControllerProvider =
    AsyncNotifierProvider<CartController, List<CartItem>>(CartController.new);

/// Derived total of the current cart (0 while loading / on error).
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartControllerProvider);
  return cart.maybeWhen(
    data: (items) => items.fold<double>(0, (sum, i) => sum + i.lineTotal),
    orElse: () => 0,
  );
});

/// Derived count of items (sum of quantities).
final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartControllerProvider);
  return cart.maybeWhen(
    data: (items) => items.fold<int>(0, (sum, i) => sum + i.quantity),
    orElse: () => 0,
  );
});
