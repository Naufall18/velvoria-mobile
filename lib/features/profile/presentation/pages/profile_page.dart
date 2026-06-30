import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final name = user?.name ?? 'Tamu Velvoria';
    final email = user?.email ?? 'Masuk untuk pengalaman penuh';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 16),
            _buildProfileHeader(name, email),
            const SizedBox(height: 20),
            _buildOrderStatus(context),
            const SizedBox(height: 20),
            _buildMenuSection(context, 'Akun Saya', [
              _MenuItem(Icons.shopping_bag_rounded, 'Pesanan Saya', 'Lacak pesanan Anda', () => context.pushNamed('orderHistory')),
              _MenuItem(Icons.location_on_rounded, 'Alamat', 'Kelola alamat pengiriman', () => context.pushNamed('addresses')),
              _MenuItem(Icons.star_rounded, 'Ulasan & Rating', 'Ulasan produk Anda', () => context.pushNamed('writeReview')),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection(context, 'Hadiah', [
              const _MenuItem(Icons.workspace_premium_rounded, 'Program Loyalitas', 'Member Platinum', null),
              const _MenuItem(Icons.confirmation_num_rounded, 'Voucher & Kupon', 'Segera hadir', null),
              const _MenuItem(Icons.card_giftcard_rounded, 'Undang Teman', 'Dapatkan hadiah per referral', null),
            ]),
            const SizedBox(height: 16),
            _buildMenuSection(context, 'Bantuan', [
              _MenuItem(Icons.help_outline_rounded, 'Pusat Bantuan', 'FAQ & dukungan', () => context.pushNamed('help')),
              _MenuItem(Icons.chat_bubble_outline_rounded, 'Live Chat', 'Hubungi kami', () => context.pushNamed('chat')),
              _MenuItem(Icons.settings_rounded, 'Pengaturan', 'Preferensi aplikasi', () => context.pushNamed('settings')),
            ]),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                title: const Text('Keluar',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 14)),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.error, size: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF11152A)],
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
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'V',
                style: const TextStyle(color: AppColors.secondary, fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(email, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: AppColors.warning, size: 14),
                      SizedBox(width: 4),
                      Text('Member Platinum',
                          style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(BuildContext context) {
    final statuses = [
      ('Belum Bayar', Icons.account_balance_wallet_rounded),
      ('Dikemas', Icons.inventory_2_rounded),
      ('Dikirim', Icons.local_shipping_rounded),
      ('Beri Ulasan', Icons.rate_review_rounded),
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
        children: statuses
            .map((s) => InkWell(
                  onTap: () => context.pushNamed('orderHistory'),
                  child: Column(
                    children: [
                      Icon(s.$2, color: AppColors.primary, size: 24),
                      const SizedBox(height: 6),
                      Text(s.$1, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<_MenuItem> items) {
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
                    subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.grey500)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400, size: 22),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    onTap: item.onTap ??
                        () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur segera hadir')),
                            ),
                  ),
                  if (i < items.length - 1) const Divider(height: 0, indent: 64, color: AppColors.grey200),
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
  final VoidCallback? onTap;
  const _MenuItem(this.icon, this.title, this.subtitle, this.onTap);
}
