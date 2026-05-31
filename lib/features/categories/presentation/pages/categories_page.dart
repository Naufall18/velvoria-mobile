import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Categories',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
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
                    child: const Icon(Icons.search_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category List
            Expanded(
              child: Row(
                children: [
                  // Left sidebar
                  _buildSidebar(),
                  // Right content
                  Expanded(child: _buildCategoryContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final categories = [
      ('All', Icons.apps_rounded, true),
      ('Fashion', Icons.checkroom_rounded, false),
      ('Watches', Icons.watch_rounded, false),
      ('Jewelry', Icons.diamond_rounded, false),
      ('Bags', Icons.luggage_rounded, false),
      ('Beauty', Icons.spa_rounded, false),
      ('Electronics', Icons.devices_rounded, false),
      ('Shoes', Icons.roller_skating_rounded, false),
      ('Home', Icons.home_rounded, false),
      ('Art', Icons.palette_rounded, false),
    ];

    return Container(
      width: 80,
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final isSelected = categories[i].$3;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Icon(categories[i].$2,
                      size: 22,
                      color:
                          isSelected ? AppColors.primary : AppColors.grey500),
                  const SizedBox(height: 4),
                  Text(categories[i].$1,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
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

  Widget _buildCategoryContent() {
    final subcategories = [
      ('Men\'s Fashion', Icons.male_rounded, '1.2K items'),
      ('Women\'s Fashion', Icons.female_rounded, '2.4K items'),
      ('Kids\' Fashion', Icons.child_care_rounded, '890 items'),
      ('Accessories', Icons.watch_rounded, '1.5K items'),
      ('Sportswear', Icons.sports_gymnastics_rounded, '670 items'),
      ('Formal Wear', Icons.business_center_rounded, '430 items'),
      ('Streetwear', Icons.skateboarding_rounded, '980 items'),
      ('Vintage', Icons.auto_awesome_rounded, '320 items'),
      ('Luxury Brands', Icons.diamond_rounded, '560 items'),
      ('Sustainable', Icons.eco_rounded, '210 items'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: subcategories.length,
        itemBuilder: (_, i) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.08),
                        AppColors.accent.withValues(alpha: 0.1)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(subcategories[i].$2,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(height: 8),
                Text(subcategories[i].$1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subcategories[i].$3,
                    style:
                        TextStyle(fontSize: 10, color: AppColors.grey500)),
              ],
            ),
          );
        },
      ),
    );
  }
}
