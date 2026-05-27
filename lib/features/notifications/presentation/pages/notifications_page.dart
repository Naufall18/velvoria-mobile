import 'package:flutter/material.dart';
import 'package:luxemart/core/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = ['All', 'Orders', 'Promos', 'Updates'];

  final _notifications = [
    {'title': 'Order Shipped! 🚚', 'desc': 'Your order #LXM-2026-0001 has been shipped via JNE Express', 'time': '2 min ago', 'icon': Icons.local_shipping, 'color': AppColors.info, 'type': 'Orders', 'read': false},
    {'title': 'Flash Sale Starting! ⚡', 'desc': 'Up to 50% off on premium brands. Limited time only!', 'time': '15 min ago', 'icon': Icons.flash_on, 'color': AppColors.warning, 'type': 'Promos', 'read': false},
    {'title': 'Payment Confirmed ✅', 'desc': 'Payment for order #LXM-2026-0001 has been confirmed', 'time': '1 hour ago', 'icon': Icons.payment, 'color': AppColors.success, 'type': 'Orders', 'read': true},
    {'title': 'Price Drop Alert! 📉', 'desc': 'An item in your wishlist is now 30% cheaper', 'time': '3 hours ago', 'icon': Icons.trending_down, 'color': AppColors.error, 'type': 'Promos', 'read': true},
    {'title': 'New Collection Available', 'desc': 'Gucci Summer 2026 collection is now live', 'time': '5 hours ago', 'icon': Icons.new_releases, 'color': AppColors.accent, 'type': 'Updates', 'read': true},
    {'title': 'Review Reminder', 'desc': 'How was your Diamond Watch? Share your experience', 'time': '1 day ago', 'icon': Icons.rate_review, 'color': AppColors.secondary, 'type': 'Orders', 'read': true},
    {'title': 'Loyalty Points Earned 🎉', 'desc': 'You earned 575 points from your last purchase', 'time': '2 days ago', 'icon': Icons.stars, 'color': AppColors.warning, 'type': 'Updates', 'read': true},
    {'title': 'Exclusive Member Offer', 'desc': 'As a Gold member, enjoy an extra 10% off this weekend', 'time': '3 days ago', 'icon': Icons.card_membership, 'color': AppColors.primary, 'type': 'Promos', 'read': true},
  ];

  @override
  void initState() { super.initState(); _tabController = TabController(length: _tabs.length, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'read', child: Text('Mark all as read')),
              const PopupMenuItem(value: 'clear', child: Text('Clear all')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController, labelColor: AppColors.primary, unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary, indicatorWeight: 3, labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          final filtered = tab == 'All' ? _notifications : _notifications.where((n) => n['type'] == tab).toList();
          if (filtered.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.notifications_none, size: 64, color: AppColors.grey300),
              const SizedBox(height: 12),
              const Text('No notifications', style: TextStyle(color: AppColors.textSecondary)),
            ]));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.grey200),
            itemBuilder: (_, i) => _buildNotificationItem(filtered[i]),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> n) {
    final read = n['read'] as bool;
    return Container(
      color: read ? Colors.white : AppColors.primary.withValues(alpha: 0.03),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: (n['color'] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 24),
        ),
        title: Row(children: [
          Expanded(child: Text(n['title'] as String, style: TextStyle(fontWeight: read ? FontWeight.w500 : FontWeight.bold, fontSize: 14))),
          if (!read) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.info, shape: BoxShape.circle)),
        ]),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          Text(n['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2),
          const SizedBox(height: 4),
          Text(n['time'] as String, style: TextStyle(fontSize: 11, color: AppColors.grey500)),
        ]),
        onTap: () {},
      ),
    );
  }
}