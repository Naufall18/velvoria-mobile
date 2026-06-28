import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../cart/presentation/cart_controller.dart';
import '../../data/product_model.dart';
import '../../data/product_repository.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(slug));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Product',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.primary),
            onPressed: () => context.pushNamed('cart'),
          ),
        ],
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              const Text('Failed to load product'),
              TextButton(
                onPressed: () => ref.invalidate(productDetailProvider(slug)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (product) => _ProductBody(product: product),
      ),
    );
  }
}

class _ProductBody extends ConsumerStatefulWidget {
  const _ProductBody({required this.product});
  final Product product;

  @override
  ConsumerState<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends ConsumerState<_ProductBody> {
  bool _adding = false;

  Future<void> _addToCart() async {
    setState(() => _adding = true);
    try {
      await ref
          .read(cartControllerProvider.notifier)
          .add(productId: widget.product.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not add to cart')),
      );
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: p.imageUrl != null
                    ? Image.network(p.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _Fallback())
                    : const _Fallback(),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.vendorName != null)
                      Text(p.vendorName!.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              letterSpacing: 1,
                              color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(Currency.idr(p.price),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(p.inStock ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color:
                                p.inStock ? AppColors.success : AppColors.error),
                        const SizedBox(width: 4),
                        Text(p.inStock ? 'In stock (${p.stock})' : 'Out of stock',
                            style: TextStyle(
                                fontSize: 13,
                                color: p.inStock
                                    ? AppColors.success
                                    : AppColors.error)),
                      ],
                    ),
                    const Divider(height: 32),
                    const Text('Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(
                      (p.description == null || p.description!.isEmpty)
                          ? 'No description available.'
                          : p.description!,
                      style: const TextStyle(
                          color: AppColors.textSecondary, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: (!p.inStock || _adding) ? null : _addToCart,
                child: _adding
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Add to Cart',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback();
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.grey100,
        child: const Center(
            child: Icon(Icons.image_outlined,
                size: 48, color: AppColors.grey400)),
      );
}
