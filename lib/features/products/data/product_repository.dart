import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import 'product_model.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
});

class ProductRepository {
  final ApiClient _api;

  ProductRepository(this._api);

  /// GET /products → paginated; products live at data.data[].
  Future<List<Product>> fetchProducts({String? search}) async {
    try {
      final res = await _api.get(
        '/products',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final list = (res.data['data']?['data'] as List?) ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } on DioException catch (e) {
      Logger.error('fetchProducts failed', tag: 'ProductRepo', error: e);
      rethrow;
    }
  }

  /// GET /products/featured → data.products[].
  Future<List<Product>> fetchFeatured() async {
    try {
      final res = await _api.get('/products/featured');
      final list = (res.data['data']?['products'] as List?) ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } on DioException catch (e) {
      Logger.error('fetchFeatured failed', tag: 'ProductRepo', error: e);
      rethrow;
    }
  }

  /// GET /products/{slug} → data.product.
  Future<Product> fetchBySlug(String slug) async {
    try {
      final res = await _api.get('/products/$slug');
      final map = res.data['data']?['product'] as Map<String, dynamic>;
      return Product.fromJson(map);
    } on DioException catch (e) {
      Logger.error('fetchBySlug failed', tag: 'ProductRepo', error: e);
      rethrow;
    }
  }
}

/// All active products (optionally filtered by [search]).
final productsProvider =
    FutureProvider.family<List<Product>, String?>((ref, search) async {
  return ref.watch(productRepositoryProvider).fetchProducts(search: search);
});

/// Featured products for the home screen.
final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).fetchFeatured();
});
