import 'package:flutter/material.dart';
import 'package:luxemart/core/theme/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  bool _showFilters = false;
  RangeValues _priceRange = const RangeValues(0, 50000000);
  final List<String> _selectedBrands = [];
  double _minRating = 0;
  String _sortBy = 'Relevance';

  final _recentSearches = [
    'Gucci Bag',
    'Rolex Watch',
    'Louis Vuitton',
    'Hermès Scarf',
    'Prada Shoes',
  ];

  final _trendingSearches = [
    'Summer Collection',
    'Limited Edition',
    'New Arrivals',
    'Best Sellers',
    'Sale Items',
    'Vintage',
    'Handmade',
    'Sustainable',
  ];

  final _brands = [
    'Gucci',
    'Louis Vuitton',
    'Hermès',
    'Chanel',
    'Prada',
    'Dior',
    'Burberry',
    'Versace',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search luxury products...',
              hintStyle: TextStyle(
                color: AppColors.textPrimary.withValues(alpha: 0.4),
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.search, color: AppColors.textPrimary.withValues(alpha: 0.4)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.mic_outlined, color: AppColors.textPrimary.withValues(alpha: 0.5)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: AppColors.textPrimary.withValues(alpha: 0.5)),
                    onPressed: () {},
                  ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: AppColors.primary,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilterPanel(),
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildSearchSuggestions()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => setState(() {
                  _priceRange = const RangeValues(0, 50000000);
                  _selectedBrands.clear();
                  _minRating = 0;
                }),
                child: const Text('Clear All', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Price Range', style: TextStyle(fontWeight: FontWeight.w600)),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 50000000,
            divisions: 100,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              'Rp ${(_priceRange.start / 1000000).toStringAsFixed(0)}M',
              'Rp ${(_priceRange.end / 1000000).toStringAsFixed(0)}M',
            ),
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          const SizedBox(height: 8),
          const Text('Brands', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _brands.map((brand) {
              final selected = _selectedBrands.contains(brand);
              return FilterChip(
                label: Text(brand),
                selected: selected,
                selectedColor: AppColors.secondary.withValues(alpha: 0.3),
                checkmarkColor: AppColors.primary,
                onSelected: (v) => setState(() {
                  v ? _selectedBrands.add(brand) : _selectedBrands.remove(brand);
                }),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: List.generate(5, (i) {
              return IconButton(
                icon: Icon(
                  i < _minRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _minRating = i + 1),
              );
            }),
          ),
          const SizedBox(height: 8),
          const Text('Sort By', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Relevance', 'Price ↑', 'Price ↓', 'Rating', 'Newest'].map((s) {
              return ChoiceChip(
                label: Text(s, style: const TextStyle(fontSize: 12)),
                selected: _sortBy == s,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _sortBy == s ? Colors.white : AppColors.textPrimary),
                onSelected: (_) => setState(() => _sortBy = s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: const Text('Clear', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          ..._recentSearches.map((s) => ListTile(
                leading: const Icon(Icons.history, color: AppColors.accent),
                title: Text(s),
                trailing: const Icon(Icons.north_west, size: 16),
                contentPadding: EdgeInsets.zero,
                dense: true,
                onTap: () => setState(() => _searchController.text = s),
              )),
          const SizedBox(height: 24),
          const Text('Trending Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trendingSearches.map((s) {
              return ActionChip(
                avatar: const Icon(Icons.trending_up, size: 16, color: AppColors.accent),
                label: Text(s, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                ),
                onPressed: () => setState(() => _searchController.text = s),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('24 results found',
                  style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.6), fontSize: 13)),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.grid_view, size: 20), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.view_list, size: 20), onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
        if (_selectedBrands.isNotEmpty)
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ..._selectedBrands.map((b) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(b, style: const TextStyle(fontSize: 11)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () => setState(() => _selectedBrands.remove(b)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )),
              ],
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 10,
            itemBuilder: (context, index) => _buildProductCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final names = [
      'Classic Leather Bag',
      'Diamond Watch',
      'Silk Scarf',
      'Designer Sunglasses',
      'Pearl Necklace',
      'Cashmere Coat',
      'Gold Ring',
      'Platinum Bracelet',
      'Emerald Earrings',
      'Vintage Clutch',
    ];
    final prices = [12500000, 45000000, 3200000, 8900000, 15600000, 22000000, 7800000, 18500000, 25000000, 9500000];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 18, color: AppColors.primary),
                  ),
                ),
                if (index % 3 == 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('-30%', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LUXE BRAND', style: TextStyle(fontSize: 9, color: AppColors.accent, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  const SizedBox(height: 2),
                  Text(names[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(Icons.star, size: 10, color: i < 4 ? Colors.amber : Colors.grey.shade300)),
                      const SizedBox(width: 4),
                      Text('(128)', style: TextStyle(fontSize: 9, color: AppColors.textPrimary.withValues(alpha: 0.5))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${(prices[index] / 1000000).toStringAsFixed(1)}M',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}