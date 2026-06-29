import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

/// Premium shimmer skeleton block — gunakan saat memuat data.
class VvSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const VvSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Skeleton berbentuk kartu produk (untuk grid/row saat loading).
class VvProductCardSkeleton extends StatelessWidget {
  final double width;
  const VvProductCardSkeleton({super.key, this.width = 160});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VvSkeleton(height: 150, radius: 18),
          SizedBox(height: 10),
          VvSkeleton(width: 60, height: 10),
          SizedBox(height: 8),
          VvSkeleton(width: 120, height: 12),
          SizedBox(height: 8),
          VvSkeleton(width: 80, height: 14),
        ],
      ),
    );
  }
}
