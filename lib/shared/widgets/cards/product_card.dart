import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Reusable product card widget used across Home, Search, Wishlist, etc.
class ProductCard extends StatelessWidget {
  final String name;
  final String brand;
  final String price;
  final String? originalPrice;
  final double rating;
  final int reviewCount;
  final IconData icon;
  final String? discountLabel;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.icon,
    this.discountLabel,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 130,
      decoration: const BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Stack(
        children: [
          Center(child: Icon(icon, size: 48, color: AppColors.grey400)),
          // Favorite button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 16,
                  color: isFavorite ? AppColors.error : AppColors.grey500,
                ),
              ),
            ),
          ),
          // Discount badge
          if (discountLabel != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  discountLabel!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            brand.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              if (originalPrice != null) ...[
                const SizedBox(width: 4),
                Text(
                  originalPrice!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
              const SizedBox(width: 3),
              Text(
                rating.toString(),
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Text(
                ' ($reviewCount)',
                style: const TextStyle(
                    fontSize: 10, color: AppColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
