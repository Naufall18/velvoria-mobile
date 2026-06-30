import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import '../../products/data/product_model.dart';

/// A wishlist row: its own id plus the embedded product.
class WishlistItem {
  final int id;
  final Product product;
  const WishlistItem({required this.id, required this.product});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    final p = json['product'] as Map<String, dynamic>? ?? const {};
    return WishlistItem(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse('${json['id']}') ?? 0,
      product: Product.fromJson(p),
    );
  }
}

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(ref.watch(apiClientProvider));
});

class WishlistRepository {
  final ApiClient _api;
  WishlistRepository(this._api);

  /// GET /wishlist → data.items[].
  Future<List<WishlistItem>> fetch() async {
    try {
      final res = await _api.get('/wishlist');
      final list = (res.data['data']?['items'] as List?) ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(WishlistItem.fromJson)
          .toList();
    } on DioException catch (e) {
      Logger.error('fetch wishlist failed', tag: 'WishlistRepo', error: e);
      rethrow;
    }
  }

  Future<void> add(int productId) async {
    await _api.post('/wishlist', data: {'product_id': productId});
  }

  Future<void> remove(int wishlistId) async {
    await _api.delete('/wishlist/$wishlistId');
  }
}

/// The signed-in user's wishlist.
final wishlistProvider = FutureProvider<List<WishlistItem>>((ref) async {
  return ref.watch(wishlistRepositoryProvider).fetch();
});
