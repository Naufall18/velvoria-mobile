import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency.dart';
import '../../../../shared/widgets/cards/product_card.dart';
import '../../../../shared/widgets/common/vv_skeleton.dart';
import '../../../categories/data/category_repository.dart';
import '../../../products/data/product_model.dart';
import '../../../products/data/product_repository.dart';

/// Live catalogue search backed by GET /products?search=…
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _recent = <String>[];
  Timer? _debounce;
  String _query = '';
  String _sort = 'Relevan';

  static const _sortOptions = ['Relevan', 'Termurah', 'Termahal', 'Rating'];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      setState(() => _query = value.trim());
    });
  }

  void _submit(String term) {
    final t = term.trim();
    if (t.isEmpty) return;
    _recent.remove(t);
    setState(() {
      _recent.insert(0, t);
      if (_recent.length > 6) _recent.removeLast();
      _query = t;
      _controller.text = t;
    });
  }

  List<Product> _sorted(List<Product> items) {
    final list = [...items];
    switch (_sort) {
      case 'Termurah':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Termahal':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: _onChanged,
            onSubmitted: _submit,
            decoration: InputDecoration(
              hintText: 'Cari produk mewah...',
              hintStyle: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                  fontSize: 14),
              prefixIcon: Icon(Icons.search,
                  color: AppColors.textPrimary.withValues(alpha: 0.4)),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
      body: _query.isEmpty ? _suggestions() : _results(),
    );
  }

  Widget _suggestions() {
    final categoriesAsync = ref.watch(categoriesProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recent.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pencarian Terakhir',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => setState(() => _recent.clear()),
                  child: const Text('Hapus',
                      style: TextStyle(color: AppColors.accent)),
                ),
              ],
            ),
            ..._recent.map((s) => ListTile(
                  leading: const Icon(Icons.history, color: AppColors.accent),
                  title: Text(s),
                  trailing: const Icon(Icons.north_west, size: 16),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  onTap: () => _submit(s),
                )),
            const SizedBox(height: 24),
          ],
          const Text('Jelajahi Kategori',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          categoriesAsync.maybeWhen(
            data: (cats) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cats
                  .map((c) => ActionChip(
                        avatar: const Icon(Icons.local_offer_outlined,
                            size: 16, color: AppColors.accent),
                        label: Text(c.name,
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: AppColors.textPrimary
                                  .withValues(alpha: 0.1)),
                        ),
                        onPressed: () => _submit(c.name),
                      ))
                  .toList(),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _results() {
    final resultsAsync = ref.watch(productsProvider(_query));
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            children: _sortOptions.map((s) {
              final selected = _sort == s;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(s, style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary),
                  onSelected: (_) => setState(() => _sort = s),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: resultsAsync.when(
            loading: () => GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              childAspectRatio: 0.58,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(
                  4, (_) => const VvProductCardSkeleton(width: double.infinity)),
            ),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 8),
                  const Text('Gagal memuat hasil'),
                  TextButton(
                    onPressed: () => ref.invalidate(productsProvider(_query)),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded,
                          size: 64, color: AppColors.grey400),
                      const SizedBox(height: 12),
                      Text('Tidak ada hasil untuk "$_query"',
                          style: const TextStyle(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }
              final sorted = _sorted(items);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${sorted.length} produk ditemukan',
                          style: TextStyle(
                              color: AppColors.textPrimary
                                  .withValues(alpha: 0.6),
                              fontSize: 13)),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: sorted.length,
                      itemBuilder: (context, i) => _card(sorted[i]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _card(Product p) {
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
      onTap: () =>
          context.pushNamed('productDetail', pathParameters: {'slug': p.slug}),
    );
  }
}
