import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../../../shared/widgets/common/vv_skeleton.dart';
import '../../../products/data/product_model.dart';
import '../../../products/data/product_repository.dart';
import '../../data/category_model.dart';
import '../../data/category_repository.dart';

/// Master-detail catalogue browser: real categories on the left rail, the
/// selected category's products on the right — all served from the API.
class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  int? _selectedId;

  // Maps a category name to a representative icon (catalogue is a fixed set).
  static const _icons = <String, IconData>{
    'bags': Icons.shopping_bag_rounded,
    'watches': Icons.watch_rounded,
    'apparel': Icons.checkroom_rounded,
    'footwear': Icons.ice_skating_rounded,
    'accessories': Icons.diamond_rounded,
    'jewelry': Icons.auto_awesome_rounded,
  };

  IconData _iconFor(String name) =>
      _icons[name.toLowerCase()] ?? Icons.category_rounded;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

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
                    child: Text('Kategori',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                  _RoundIconButton(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => context.pushNamed('cart'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: categoriesAsync.when(
                loading: () => const _CategoriesSkeleton(),
                error: (e, _) => _ErrorState(
                  onRetry: () => ref.invalidate(categoriesProvider),
                ),
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Center(child: Text('Belum ada kategori.'));
                  }
                  final selected = _selectedId ?? categories.first.id;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Sidebar(
                        categories: categories,
                        selectedId: selected,
                        iconFor: _iconFor,
                        onSelect: (id) => setState(() => _selectedId = id),
                      ),
                      Expanded(
                        child: _CategoryProducts(categoryId: selected),
                      ),
                    ],
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

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.categories,
    required this.selectedId,
    required this.iconFor,
    required this.onSelect,
  });

  final List<CategoryModel> categories;
  final int selectedId;
  final IconData Function(String) iconFor;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      margin: const EdgeInsets.only(left: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = cat.id == selectedId;
          return GestureDetector(
            onTap: () => onSelect(cat.id),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: isSelected
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25))
                    : null,
              ),
              child: Column(
                children: [
                  Icon(iconFor(cat.name),
                      size: 22,
                      color:
                          isSelected ? AppColors.primary : AppColors.grey500),
                  const SizedBox(height: 6),
                  Text(cat.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          height: 1.1,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryProducts extends ConsumerWidget {
  const _CategoryProducts({required this.categoryId});
  final int categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider(categoryId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
      child: productsAsync.when(
        loading: () => GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.56,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: List.generate(
              4, (_) => const VvProductCardSkeleton(width: double.infinity)),
        ),
        error: (e, _) => _ErrorState(
          onRetry: () =>
              ref.invalidate(productsByCategoryProvider(categoryId)),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('Belum ada produk di kategori ini.',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.56,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => _card(context, products[i]),
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, Product p) {
    final hasDiscount = p.comparePrice != null && p.comparePrice! > p.price;
    final pct = hasDiscount
        ? (((p.comparePrice! - p.price) / p.comparePrice!) * 100).round()
        : 0;
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
      width: double.infinity,
      onTap: () => context.pushNamed('productDetail',
          pathParameters: {'slug': p.slug}),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}

class _CategoriesSkeleton extends StatelessWidget {
  const _CategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 92,
          margin: const EdgeInsets.only(left: 12, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: List.generate(
              6,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: VvSkeleton(height: 56, radius: 14),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.56,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(
                  4, (_) => const VvProductCardSkeleton(width: double.infinity)),
            ),
          ),
        ),
      ],
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
          const Text('Gagal memuat data'),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
