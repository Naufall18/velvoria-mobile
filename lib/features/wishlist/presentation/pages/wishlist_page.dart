import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../../../shared/widgets/common/vv_skeleton.dart';
import '../../../products/data/product_model.dart';
import '../../data/wishlist_repository.dart';

/// The user's saved products — backed by the real /wishlist API.
class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Wishlist',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                  wishlistAsync.maybeWhen(
                    data: (items) => Text('${items.length} item',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: wishlistAsync.when(
                loading: () => GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  children: List.generate(4,
                      (_) => const VvProductCardSkeleton(width: double.infinity)),
                ),
                error: (e, _) => _ErrorState(
                  onRetry: () => ref.invalidate(wishlistProvider),
                ),
                data: (items) {
                  if (items.isEmpty) return const _EmptyWishlist();
                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(wishlistProvider),
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          _WishlistCard(item: items[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistCard extends ConsumerStatefulWidget {
  const _WishlistCard({required this.item});
  final WishlistItem item;

  @override
  ConsumerState<_WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends ConsumerState<_WishlistCard> {
  bool _removing = false;

  Future<void> _remove() async {
    setState(() => _removing = true);
    try {
      await ref.read(wishlistRepositoryProvider).remove(widget.item.id);
      ref.invalidate(wishlistProvider);
    } catch (_) {
      if (mounted) {
        setState(() => _removing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus dari wishlist')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product p = widget.item.product;
    final hasDiscount = p.comparePrice != null && p.comparePrice! > p.price;
    final pct = hasDiscount
        ? (((p.comparePrice! - p.price) / p.comparePrice!) * 100).round()
        : 0;
    return Stack(
      children: [
        ProductCard(
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
          onTap: () => context
              .pushNamed('productDetail', pathParameters: {'slug': p.slug}),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _removing ? null : _remove,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6),
                ],
              ),
              child: _removing
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.error),
                    )
                  : const Icon(Icons.favorite_rounded,
                      size: 18, color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded,
              size: 64, color: AppColors.grey400),
          SizedBox(height: 12),
          Text('Wishlist Anda masih kosong',
              style: TextStyle(color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text('Simpan produk favorit untuk nanti',
              style: TextStyle(color: AppColors.grey400, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 8),
          const Text('Gagal memuat wishlist'),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
