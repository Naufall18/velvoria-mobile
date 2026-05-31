import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Wishlist',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                  Text('6 items',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Collection chips
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('All', true),
                  _chip('Fashion', false),
                  _chip('Watches', false),
                  _chip('Jewelry', false),
                  _chip('Bags', false),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.65,
                ),
                itemCount: 6,
                itemBuilder: (_, i) => _wishlistCard(i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: selected ? AppColors.primary : AppColors.grey300),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppColors.grey700)),
      ),
    );
  }

  Widget _wishlistCard(int i) {
    final names = ['Classic Leather Bag', 'Diamond Watch', 'Silk Scarf', 'Gold Necklace', 'Designer Sunglasses', 'Pearl Earrings'];
    final prices = ['\$1,299', '\$4,500', '\$380', '\$2,100', '\$650', '\$890'];
    final icons = [Icons.luggage_rounded, Icons.watch_rounded, Icons.checkroom_rounded, Icons.diamond_rounded, Icons.visibility_rounded, Icons.diamond_outlined];
    final hasDiscount = i == 1 || i == 4;
    final inStock = i != 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(child: Icon(icons[i], size: 48, color: AppColors.grey400)),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.favorite_rounded, size: 18, color: AppColors.error),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                      child: const Text('Price Drop!', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                    ),
                  ),
                if (!inStock)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Center(
                      child: Text('Out of Stock', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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
                Text('LUXE BRAND', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.accent, letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(prices[i], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 8),
                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: inStock ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.grey300,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: Text(inStock ? 'Add to Cart' : 'Notify Me', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
