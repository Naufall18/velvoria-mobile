import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvoria/core/theme/app_colors.dart';
import 'package:velvoria/core/utils/currency.dart';
import '../../data/order_model.dart';
import '../../data/order_repository.dart';

class OrderHistoryPage extends ConsumerStatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // (label, status key — null means "All")
  static const _tabs = <(String, String?)>[
    ('All', null),
    ('Pending', 'pending'),
    ('Processing', 'processing'),
    ('Shipped', 'shipped'),
    ('Delivered', 'delivered'),
    ('Cancelled', 'cancelled'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Orders',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () => ref.invalidate(ordersProvider),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              const Text('Failed to load orders'),
              TextButton(
                onPressed: () => ref.invalidate(ordersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) => TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) {
            final filtered = tab.$2 == null
                ? orders
                : orders.where((o) => o.status == tab.$2).toList();
            if (filtered.isEmpty) return _EmptyState(label: tab.$1);
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(ordersProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _OrderCard(order: filtered[i]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusStyle(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.orderNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${order.itemCount} item(s)'
              '${order.paymentMethod != null ? ' · ${order.paymentMethod!.toUpperCase()}' : ''}',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          if (order.createdAt != null)
            Text(order.createdAt!.split('T').first,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          const Divider(height: 20),
          Row(
            children: [
              const Text('Total',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Text(Currency.idr(order.total),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  (String, Color) _statusStyle(String status) {
    switch (status) {
      case 'pending':
        return ('Pending', AppColors.info);
      case 'confirmed':
      case 'processing':
        return ('Processing', AppColors.warning);
      case 'shipped':
        return ('Shipped', AppColors.info);
      case 'delivered':
        return ('Delivered', AppColors.success);
      case 'cancelled':
        return ('Cancelled', AppColors.error);
      case 'refunded':
        return ('Refunded', AppColors.error);
      default:
        return (status, AppColors.textSecondary);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined,
              size: 64, color: AppColors.grey400),
          const SizedBox(height: 12),
          Text('No $label orders',
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
