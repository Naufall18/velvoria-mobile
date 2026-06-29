import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              const Text('Gagal memuat produk'),
              TextButton(
                onPressed: () => ref.invalidate(productDetailProvider(slug)),
                child: const Text('Coba lagi'),
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
  int _qty = 1;

  Future<void> _addToCart() async {
    setState(() => _adding = true);
    try {
      await ref.read(cartControllerProvider.notifier).add(productId: widget.product.id, quantity: _qty);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} ditambahkan ke keranjang'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambah ke keranjang')),
      );
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = p.comparePrice != null && p.comparePrice! > p.price;
    final pct = hasDiscount ? (((p.comparePrice! - p.price) / p.comparePrice!) * 100).round() : 0;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Gambar + tombol kembali
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: p.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: p.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(color: AppColors.grey100),
                              errorWidget: (_, __, ___) => const _Fallback(),
                            )
                          : const _Fallback(),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _circleBtn(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                            _circleBtn(Icons.shopping_bag_outlined, () => context.pushNamed('cart')),
                          ],
                        ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        left: 16, bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(999)),
                          child: Text('-$pct%',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 28, height: 3, color: const Color(0xFFC5A572)),
                      const SizedBox(height: 14),
                      if (p.brandName != null || p.vendorName != null)
                        Text((p.brandName ?? p.vendorName!).toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700, color: AppColors.accent)),
                      const SizedBox(height: 6),
                      Text(p.name,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (p.rating > 0) ...[
                            const Icon(Icons.star_rounded, size: 18, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(p.rating.toStringAsFixed(1),
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('  (${p.totalReviews} ulasan)',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Currency.idr(p.price),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          if (hasDiscount) ...[
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(Currency.idr(p.comparePrice!),
                                  style: const TextStyle(
                                      color: AppColors.grey500,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(p.inStock ? Icons.check_circle : Icons.cancel,
                              size: 16, color: p.inStock ? AppColors.success : AppColors.error),
                          const SizedBox(width: 4),
                          Text(p.inStock ? 'Tersedia (${p.stock})' : 'Stok habis',
                              style: TextStyle(fontSize: 13, color: p.inStock ? AppColors.success : AppColors.error)),
                        ],
                      ),
                      const Divider(height: 32),
                      Text('Deskripsi',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      Text(
                        (p.description == null || p.description!.isEmpty)
                            ? 'Belum ada deskripsi untuk produk ini.'
                            : p.description!,
                        style: const TextStyle(color: AppColors.textSecondary, height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      _trustRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _bottomBar(p),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _trustRow() {
    final items = [
      (Icons.verified_user_outlined, '100% Asli'),
      (Icons.local_shipping_outlined, 'Pengiriman Aman'),
      (Icons.payments_outlined, 'Bisa COD'),
    ];
    return Row(
      children: items
          .map((e) => Expanded(
                child: Column(
                  children: [
                    Icon(e.$1, color: AppColors.accent, size: 22),
                    const SizedBox(height: 6),
                    Text(e.$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _bottomBar(Product p) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.background, borderRadius: BorderRadius.circular(999)),
              child: Row(
                children: [
                  _qtyBtn(Icons.remove, () => setState(() => _qty = (_qty - 1).clamp(1, 99))),
                  SizedBox(width: 28, child: Text('$_qty', textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700))),
                  _qtyBtn(Icons.add, () => setState(() => _qty = (_qty + 1).clamp(1, 99))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  onPressed: (!p.inStock || _adding) ? null : _addToCart,
                  child: _adding
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Tambah ke Keranjang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(12), child: Icon(icon, size: 18, color: AppColors.primary)),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback();
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.grey100,
        child: const Center(child: Icon(Icons.image_outlined, size: 48, color: AppColors.grey400)),
      );
}
