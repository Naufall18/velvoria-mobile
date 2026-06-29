import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../../../shared/widgets/common/vv_skeleton.dart';
import '../../../cart/presentation/cart_controller.dart';
import '../../data/product_model.dart';
import '../../data/product_repository.dart';

/// Katalog produk berbasis API — pintu masuk alur belanja.
class ProductsListPage extends ConsumerStatefulWidget {
  const ProductsListPage({super.key});

  @override
  ConsumerState<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends ConsumerState<ProductsListPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider(null));
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Koleksi',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                onPressed: () => context.pushNamed('cart'),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text('$cartCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Cari produk mewah...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey400),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFECE6DF)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFECE6DF)),
                ),
              ),
            ),
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                childAspectRatio: 0.58,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: List.generate(4, (_) => const VvProductCardSkeleton(width: double.infinity)),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 8),
                    const Text('Gagal memuat produk'),
                    TextButton(
                      onPressed: () => ref.invalidate(productsProvider(null)),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
              data: (products) {
                final items = _query.isEmpty
                    ? products
                    : products.where((p) =>
                        p.name.toLowerCase().contains(_query) ||
                        (p.brandName?.toLowerCase().contains(_query) ?? false)).toList();
                if (items.isEmpty) {
                  return const Center(child: Text('Tidak ada produk yang cocok.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(productsProvider(null)),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) => _card(context, items[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, Product p) {
    final hasDiscount = p.comparePrice != null && p.comparePrice! > p.price;
    final pct = hasDiscount ? (((p.comparePrice! - p.price) / p.comparePrice!) * 100).round() : 0;
    return ProductCard(
      name: p.name,
      brand: p.brandName ?? p.vendorName ?? 'Velvoria',
      price: Currency.idr(p.price),
      originalPrice: hasDiscount ? Currency.idr(p.comparePrice!) : null,
      rating: p.rating,
      reviewCount: p.totalReviews,
      icon: Icons.shopping_bag_rounded,
      imageUrl: p.imageUrl,
      discountLabel: hasDiscount ? '-$pct%' : null,
      width: double.infinity,
      onTap: () => context.pushNamed('productDetail', pathParameters: {'slug': p.slug}),
    );
  }
}
