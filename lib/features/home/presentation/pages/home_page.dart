import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../../../shared/widgets/common/fade_in.dart';
import '../../../../shared/widgets/common/vv_skeleton.dart';
import '../../../products/data/product_model.dart';
import '../../../products/data/product_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider(null));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(productsProvider(null)),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildSearchBar(context)),
              SliverToBoxAdapter(child: _buildCategories(context)),
              SliverToBoxAdapter(child: _buildBannerCarousel()),
              SliverToBoxAdapter(child: _buildFlashDeals()),
              SliverToBoxAdapter(child: _sectionTitle(context, 'Trending Mewah')),
              SliverToBoxAdapter(child: _productRow(context, productsAsync, 0)),
              SliverToBoxAdapter(child: _sectionTitle(context, 'Baru Tiba')),
              SliverToBoxAdapter(child: _productRow(context, productsAsync, 6)),
              SliverToBoxAdapter(child: _buildTopBrands(context)),
              SliverToBoxAdapter(child: _sectionTitle(context, 'Rekomendasi untuk Anda')),
              _buildProductGrid(context, productsAsync),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat datang 👋',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 2),
                Text('Velvoria',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ],
            ),
          ),
          _iconBtn(Icons.notifications_none_rounded, badge: true,
              onTap: () => context.pushNamed('notifications')),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, {bool badge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          if (badge)
            Positioned(
              top: 6, right: 8,
              child: Container(width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: GestureDetector(
        onTap: () => context.pushNamed('search'),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFECE6DF)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded, color: AppColors.grey400, size: 22),
              const SizedBox(width: 10),
              const Text('Cari produk mewah...',
                  style: TextStyle(color: AppColors.grey400, fontSize: 14)),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final cats = [
      ('Tas', Icons.luggage_rounded),
      ('Jam', Icons.watch_rounded),
      ('Pakaian', Icons.checkroom_rounded),
      ('Sepatu', Icons.ice_skating_rounded),
      ('Aksesori', Icons.style_rounded),
      ('Perhiasan', Icons.diamond_rounded),
    ];
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => context.pushNamed('products'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.accent.withValues(alpha: 0.10)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(cats[i].$2, color: AppColors.primary, size: 24),
              ),
              const SizedBox(height: 6),
              Text(cats[i].$1, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    final colors = [
      [AppColors.primary, const Color(0xFF2A3158)],
      [AppColors.accent, const Color(0xFF1D4745)],
      [const Color(0xFF8B2635), const Color(0xFFB5454F)],
    ];
    final titles = ['Koleksi Musim Ini\n2026', 'Brand Eksklusif\nDiskon s/d 40%', 'Barang Mewah\nTerbaru'];
    return SizedBox(
      height: 170,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: 0.88),
        itemCount: 3,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors[i], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              Positioned(right: -20, bottom: -20,
                  child: Icon(Icons.diamond_rounded, size: 120, color: Colors.white.withValues(alpha: 0.08))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(titles[i],
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, height: 1.3)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Text('Belanja Sekarang',
                          style: TextStyle(color: colors[i][0], fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashDeals() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.flash_on_rounded, color: AppColors.error, size: 28),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Flash Deals',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.error)),
                  Text('Berakhir dalam 02:34:15', style: TextStyle(fontSize: 12, color: AppColors.error)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(20)),
              child: const Text('Lihat Semua',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary)),
          GestureDetector(
            onTap: () => context.pushNamed('products'),
            child: const Text('Lihat Semua',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  ProductCard _toCard(BuildContext context, Product p) {
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
      onTap: () => context.pushNamed('productDetail', pathParameters: {'slug': p.slug}),
    );
  }

  Widget _productRow(BuildContext context, AsyncValue<List<Product>> async, int skip) {
    return SizedBox(
      height: 278,
      child: async.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, __) => const VvProductCardSkeleton(width: 160),
        ),
        error: (_, __) => const Center(child: Text('Gagal memuat produk')),
        data: (products) {
          final items = products.skip(skip).take(6).toList();
          if (items.isEmpty) return const SizedBox.shrink();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => FadeIn(
              delay: Duration(milliseconds: 40 * i),
              child: _toCard(context, items[i]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBrands(BuildContext context) {
    final brands = ['Aurelia', 'Noir & Co', 'Maison Vela', 'Lumen', 'Velour', 'Étoile'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Brand Pilihan'),
        SizedBox(
          height: 76,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => Container(
              width: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.grey200),
              ),
              alignment: Alignment.center,
              child: Text(brands[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context, AsyncValue<List<Product>> async) {
    return async.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Expanded(child: VvProductCardSkeleton()),
            SizedBox(width: 14),
            Expanded(child: VvProductCardSkeleton()),
          ]),
        ),
      ),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (products) {
        final items = products.take(8).toList();
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.58,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => _toCard(context, items[i]),
              childCount: items.length,
            ),
          ),
        );
      },
    );
  }
}
