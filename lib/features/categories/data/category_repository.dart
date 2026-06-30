import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import 'category_model.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(apiClientProvider));
});

class CategoryRepository {
  final ApiClient _api;

  CategoryRepository(this._api);

  /// GET /categories → data.categories[] (top-level, with products_count).
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final res = await _api.get('/categories');
      final list = (res.data['data']?['categories'] as List?) ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } on DioException catch (e) {
      Logger.error('fetchCategories failed', tag: 'CategoryRepo', error: e);
      rethrow;
    }
  }
}

/// Top-level catalog categories.
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return ref.watch(categoryRepositoryProvider).fetchCategories();
});
