import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 16),
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 20),
            // Stats
            _buildStats(),
            const SizedBox(height: 20),
            // Order Status
            _buildOrderStatus(),
            const SizedBox(height: 20),
            // Menu Sections
            _buildMenuSection('My Account', [
              _MenuItem(Icons.shopping_bag_rounded, 'My Orders', 'Track your orders'),
              _MenuItem(Icons.location_on_rounded, 'Addresses', 'Manage delivery addresses'),
              _MenuItem(Icons.payment_rounded, 'Payment Methods', 'Cards & wallets'),
              _MenuItem(Icons.star_rounded, 'Reviews & Ratings', 'Your product reviews'),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection('Rewards', [
              _MenuItem(Icons.workspace_premium_rounded, 'Loyalty Program', 'Gold Member • 2,450 pts'),
              _MenuItem(Icons.confirmation_num_rounded, 'Vouchers & Coupons', '3 available'),
              _MenuItem(Icons.card_giftcard_rounded, 'Invite Friends', 'Earn \$10 per referral'),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection('Support', [
              _MenuItem(Icons.help_outline_rounded, 'Help Center', 'FAQs & support'),
              _MenuItem(Icons.chat_bubble_outline_rounded, 'Live Chat', 'Chat with us'),
              _MenuItem(Icons.settings_rounded, 'Settings', 'App preferences'),
            ]),
            const SizedBox(height: 16),
            // Logout
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 14)),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error, size: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF2A3158)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Doe', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('john.doe@email.com', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 14),
                      SizedBox(width: 4),
                      Text('Gold Member', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _statCard('2,450', 'Points', Icons.stars_rounded, const Color(0xFFF59E0B)),
        const SizedBox(width: 12),
        _statCard('3', 'Vouchers', Icons.confirmation_num_rounded, AppColors.accent),
        const SizedBox(width: 12),
        _statCard('12', 'Orders', Icons.shopping_bag_rounded, AppColors.primary),
      ],
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    final statuses = [
      ('To Pay', Icons.account_balance_wallet_rounded, '2'),
      ('To Ship', Icons.inventory_2_rounded, '1'),
      ('To Receive', Icons.local_shipping_rounded, '3'),
      ('To Review', Icons.rate_review_rounded, '1'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: statuses.map((s) => Column(
          children: [
            Badge(
              label: Text(s.$3, style: const TextStyle(fontSize: 9)),
              backgroundColor: AppColors.error,
              child: Icon(s.$2, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 6),
            Text(s.$1, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: AppColors.primary, size: 20),
                    ),
                    title: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    subtitle: Text(item.subtitle, style: TextStyle(fontSize: 11, color: AppColors.grey500)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400, size: 22),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    onTap: () {},
                  ),
                  if (i < items.length - 1) Divider(height: 0, indent: 64, color: AppColors.grey200),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MenuItem(this.icon, this.title, this.subtitle);
}
