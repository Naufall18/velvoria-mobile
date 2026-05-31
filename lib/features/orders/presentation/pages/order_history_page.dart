import 'package:flutter/material.dart';
import 'package:velvoria/core/theme/app_colors.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});
  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = ['All', 'To Pay', 'To Ship', 'To Receive', 'Completed', 'Cancelled'];

  final _orders = [
    {'id': 'LXM-2026-0001', 'date': '27 May 2026', 'items': 2, 'total': 'Rp 57,500,000', 'status': 'To Receive', 'color': AppColors.warning},
    {'id': 'LXM-2026-0002', 'date': '25 May 2026', 'items': 1, 'total': 'Rp 8,900,000', 'status': 'Completed', 'color': AppColors.success},
    {'id': 'LXM-2026-0003', 'date': '22 May 2026', 'items': 3, 'total': 'Rp 32,100,000', 'status': 'Completed', 'color': AppColors.success},
    {'id': 'LXM-2026-0004', 'date': '18 May 2026', 'items': 1, 'total': 'Rp 3,200,000', 'status': 'Cancelled', 'color': AppColors.error},
    {'id': 'LXM-2026-0005', 'date': '15 May 2026', 'items': 2, 'total': 'Rp 18,500,000', 'status': 'To Pay', 'color': AppColors.info},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('My Orders', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController, isScrollable: true,
          labelColor: AppColors.primary, unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary, indicatorWeight: 3, labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          final filtered = tab == 'All' ? _orders : _orders.where((o) => o['status'] == tab).toList();
          if (filtered.isEmpty) return _emptyState(tab);
          return ListView.builder(
            padding: const EdgeInsets.all(16), itemCount: filtered.length,
            itemBuilder: (_, i) => _buildOrderCard(filtered[i]),
          );
        }).toList(),
      ),
    );
  }

  Widget _emptyState(String tab) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.grey300),
      const SizedBox(height: 16),
      Text('No $tab orders', style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
    ]));
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('#${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: (order['color'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Text(order['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: order['color'] as Color)),
          ),
        ]),
        const SizedBox(height: 8),
        Text('${order['date']} · ${order['items']} items', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        Row(children: [
          ...List.generate(
            (order['items'] as int).clamp(0, 3),
            (i) => Container(width: 44, height: 44, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.grey400)),
          ),
          const Spacer(),
          Text(order['total'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          if (order['status'] == 'To Receive') ...[
            Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Track', style: TextStyle(fontSize: 12)))),
            const SizedBox(width: 8),
          ],
          if (order['status'] == 'Completed') ...[
            Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Review', style: TextStyle(fontSize: 12)))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Reorder', style: TextStyle(fontSize: 12, color: Colors.white)))),
          ],
          if (order['status'] == 'To Pay')
            Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Pay Now', style: TextStyle(fontSize: 12, color: Colors.white)))),
          if (order['status'] == 'Cancelled')
            Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('View Details', style: TextStyle(fontSize: 12)))),
        ]),
      ]),
    );
  }
}
