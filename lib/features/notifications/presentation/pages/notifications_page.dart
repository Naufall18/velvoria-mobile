import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:velvoria/core/theme/app_colors.dart';
import '../../../orders/data/order_model.dart';
import '../../../orders/data/order_repository.dart';

/// Activity feed derived from the user's real orders — no mock notifications.
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: const Text('Notifikasi',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () => ref.invalidate(ordersProvider),
          ),
        ],
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const _Empty(
          icon: Icons.error_outline,
          message: 'Gagal memuat notifikasi',
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const _Empty(
              icon: Icons.notifications_none_rounded,
              message: 'Belum ada notifikasi',
            );
          }
          final sorted = [...orders]..sort((a, b) =>
              (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sorted.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.grey200),
            itemBuilder: (_, i) => _NotificationTile(order: sorted[i]),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final (title, desc, icon, color) = _content(order);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
              maxLines: 2),
          if (order.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(order.createdAt!.split('T').first,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.grey500)),
          ],
        ],
      ),
      onTap: () => context.pushNamed('orderHistory'),
    );
  }

  (String, String, IconData, Color) _content(OrderModel o) {
    switch (o.status) {
      case 'pending':
        return (
          'Menunggu pembayaran',
          'Pesanan ${o.orderNumber} menunggu konfirmasi pembayaran.',
          Icons.account_balance_wallet_rounded,
          AppColors.warning,
        );
      case 'confirmed':
      case 'processing':
        return (
          'Pesanan diproses',
          'Pesanan ${o.orderNumber} sedang kami siapkan.',
          Icons.inventory_2_rounded,
          AppColors.info,
        );
      case 'shipped':
        return (
          'Pesanan dikirim',
          'Pesanan ${o.orderNumber} sedang dalam perjalanan.',
          Icons.local_shipping_rounded,
          AppColors.info,
        );
      case 'delivered':
        return (
          'Pesanan selesai',
          'Pesanan ${o.orderNumber} telah tiba. Beri ulasan, yuk!',
          Icons.check_circle_rounded,
          AppColors.success,
        );
      case 'cancelled':
        return (
          'Pesanan dibatalkan',
          'Pesanan ${o.orderNumber} telah dibatalkan.',
          Icons.cancel_rounded,
          AppColors.error,
        );
      default:
        return (
          'Pembaruan pesanan',
          'Pesanan ${o.orderNumber} diperbarui.',
          Icons.notifications_rounded,
          AppColors.primary,
        );
    }
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: AppColors.grey300),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
