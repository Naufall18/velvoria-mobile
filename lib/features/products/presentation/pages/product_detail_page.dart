import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Image Header
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.share_rounded, color: AppColors.primary, size: 20),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.favorite_border_rounded, color: AppColors.primary, size: 20),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.grey100,
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.luggage_rounded, size: 120, color: AppColors.grey300)),
                    // Image indicators
                    Positioned(
                      bottom: 16, left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) => Container(
                          width: i == 0 ? 24 : 8, height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: i == 0 ? AppColors.primary : AppColors.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                    ),
                    // AR badge
                    Positioned(
                      bottom: 16, right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('AR Try-On', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text('LUXE BRAND', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent, letterSpacing: 0.5)),
                        ),
                        const Spacer(),
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                        const SizedBox(width: 4),
                        const Text('4.8', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text(' (324 reviews)', style: TextStyle(fontSize: 12, color: AppColors.grey500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Title
                    const Text('Classic Premium Leather Bag', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('\$1,299', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(width: 10),
                        Text('\$1,599', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.grey400, decoration: TextDecoration.lineThrough)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: const Text('-19%', style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Color
                    const Text('Color', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: [Colors.black, Colors.brown, const Color(0xFFD4A574), Colors.grey].map((c) => Container(
                        width: 36, height: 36,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(10),
                          border: c == Colors.black ? Border.all(color: AppColors.primary, width: 2) : null,
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Size
                    const Text('Size', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: ['S', 'M', 'L'].map((s) => Container(
                        width: 48, height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: s == 'M' ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: s == 'M' ? AppColors.primary : AppColors.grey300),
                        ),
                        child: Center(child: Text(s, style: TextStyle(fontWeight: FontWeight.w600, color: s == 'M' ? Colors.white : AppColors.grey700))),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Seller
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('LUXE BRAND Official', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                Text('⭐ 4.9 • 99% positive', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(10)),
                            child: const Text('Visit', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Description
                    const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      'Crafted from premium Italian leather, this timeless bag combines elegance with functionality. Features gold-tone hardware, adjustable strap, and multiple interior compartments.',
                      style: TextStyle(fontSize: 13, color: AppColors.grey600, height: 1.6),
                    ),
                    const SizedBox(height: 20),
                    // Shipping
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping_rounded, color: AppColors.success, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Free Shipping', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success)),
                                Text('Estimated delivery: 3-5 business days', style: TextStyle(fontSize: 11, color: AppColors.grey600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Reviews preview
                    Row(
                      children: [
                        const Text('Reviews (324)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('See All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildReview('Sarah M.', 5, 'Absolutely stunning bag! The leather quality is exceptional.'),
                    _buildReview('James K.', 4, 'Great quality, slightly smaller than expected but love it.'),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildReview(String name, int rating, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary))),
              const SizedBox(width: 10),
              Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
              ...List.generate(5, (i) => Icon(i < rating ? Icons.star_rounded : Icons.star_border_rounded, size: 14, color: const Color(0xFFF59E0B))),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: TextStyle(fontSize: 12, color: AppColors.grey600, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(border: Border.all(color: AppColors.grey300), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(border: Border.all(color: AppColors.grey300), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Buy Now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
