import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Reusable product card mewah dipakai di Home, Search, Wishlist, dll.
/// Hairline champagne-gold + bayangan halus = signature Velvoria.
class ProductCard extends StatelessWidget {
  final String name;
  final String brand;
  final String price;
  final String? originalPrice;
  final double rating;
  final int reviewCount;
  final IconData icon;
  final String? imageUrl;
  final String? discountLabel;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final double width;

  const ProductCard({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.icon,
    this.imageUrl,
    this.discountLabel,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.width = 160,
  });

  static const _gold = Color(0xFFC5A572);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFECE6DF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image flexes to fill whatever height the cell/row provides so the
            // card never overflows on smaller/denser screens.
            Expanded(child: _buildImageSection()),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.grey100),
                    errorWidget: (_, __, ___) => _iconPlaceholder(),
                  )
                : _iconPlaceholder(),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 16,
                  color: isFavorite ? AppColors.error : AppColors.grey500,
                ),
              ),
            ),
          ),
          if (discountLabel != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  discountLabel!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _iconPlaceholder() => Container(
        color: AppColors.grey100,
        child: Center(child: Icon(icon, size: 44, color: AppColors.grey400)),
      );

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hairline emas signature
          Container(width: 28, height: 2, color: _gold),
          const SizedBox(height: 8),
          Text(
            brand.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
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
              Text(rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              Text(' ($reviewCount)',
                  style: const TextStyle(fontSize: 10, color: AppColors.grey500)),
            ],
          ),
        ],
      ),
    );
  }
}
