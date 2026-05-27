import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(child: _buildHeader(context)),
            // Search Bar
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            // Categories
            SliverToBoxAdapter(child: _buildCategories()),
            // Banner Carousel
            SliverToBoxAdapter(child: _buildBannerCarousel()),
            // Flash Deals
            SliverToBoxAdapter(child: _buildFlashDeals()),
            // Trending
            SliverToBoxAdapter(child: _buildSectionTitle('Trending Luxury', 'See All')),
            SliverToBoxAdapter(child: _buildProductRow()),
            // New Arrivals
            SliverToBoxAdapter(child: _buildSectionTitle('New Arrivals', 'See All')),
            SliverToBoxAdapter(child: _buildProductRow()),
            // Top Brands
            SliverToBoxAdapter(child: _buildTopBrands()),
            // Recommended
            SliverToBoxAdapter(child: _buildSectionTitle('Recommended for You', 'See All')),
            SliverToBoxAdapter(child: _buildProductGrid()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Morning 👋',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                const Text('Welcome to LuxeMart',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ],
            ),
          ),
          _iconBtn(Icons.notifications_none_rounded, badge: true),
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

  Widget _iconBtn(IconData icon, {bool badge = false}) {
    return Stack(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        if (badge)
          Positioned(
            top: 6,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.error, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.search_rounded, color: AppColors.grey400, size: 22),
              const SizedBox(width: 10),
              Text('Search luxury products...',
                  style: TextStyle(color: AppColors.grey400, fontSize: 14)),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final cats = [
      ('Fashion', Icons.checkroom_rounded),
      ('Watches', Icons.watch_rounded),
      ('Jewelry', Icons.diamond_rounded),
      ('Bags', Icons.luggage_rounded),
      ('Beauty', Icons.spa_rounded),
      ('Electronics', Icons.devices_rounded),
      ('Shoes', Icons.roller_skating_rounded),
      ('More', Icons.more_horiz_rounded),
    ];
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          return Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.accent.withValues(alpha: 0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(cats[i].$2, color: AppColors.primary, size: 24),
              ),
              const SizedBox(height: 6),
              Text(cats[i].$1,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: 0.88),
        itemCount: 3,
        itemBuilder: (_, i) {
          final colors = [
            [AppColors.primary, const Color(0xFF2A3158)],
            [AppColors.accent, const Color(0xFF1D4745)],
            [const Color(0xFF8B2635), const Color(0xFFB5454F)],
          ];
          final titles = [
            'Summer Collection\n2026',
            'Exclusive Brands\nUp to 40% Off',
            'New Luxury\nArrivals'
          ];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors[i],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(Icons.diamond_rounded,
                      size: 120, color: Colors.white.withValues(alpha: 0.08)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(titles[i],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.3)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Shop Now',
                            style: TextStyle(
                                color: colors[i][0],
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Flash Deals',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.error)),
                  Text('Ends in 02:34:15',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.error.withValues(alpha: 0.7))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('View All',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          Text(action,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildProductRow() {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _productCard(i),
      ),
    );
  }

  Widget _productCard(int i) {
    final names = [
      'Classic Leather Bag',
      'Diamond Watch',
      'Silk Scarf',
      'Gold Necklace',
      'Designer Sunglasses'
    ];
    final prices = ['\$1,299', '\$4,500', '\$380', '\$2,100', '\$650'];
    final icons = [
      Icons.luggage_rounded,
      Icons.watch_rounded,
      Icons.checkroom_rounded,
      Icons.diamond_rounded,
      Icons.visibility_rounded,
    ];
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(child: Icon(icons[i], size: 48, color: AppColors.grey400)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.favorite_border_rounded,
                        size: 16, color: AppColors.grey500),
                  ),
                ),
                if (i == 1)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('-30%',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LUXE BRAND',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                        letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(names[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(prices[i],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 3),
                    Text('4.${8 - i}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                    Text(' (${120 + i * 30})',
                        style:
                            TextStyle(fontSize: 10, color: AppColors.grey500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBrands() {
    final brands = ['Gucci', 'Prada', 'Chanel', 'LV', 'Hermès', 'Dior'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Top Brands', 'See All'),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Center(
                child: Text(brands[i],
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.68,
        ),
        itemCount: 4,
        itemBuilder: (_, i) => _productCard(i),
      ),
    );
  }
}