import 'package:flutter/material.dart';
import 'package:luxemart/core/theme/app_colors.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;
  const OrderTrackingPage({super.key, this.orderId = 'LXM-2026-0001'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('Track Order', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 16),
            _buildMapPlaceholder(),
            const SizedBox(height: 16),
            _buildTimeline(),
            const SizedBox(height: 16),
            _buildCourierInfo(),
            const SizedBox(height: 16),
            _buildOrderItems(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {}, icon: const Icon(Icons.report_problem_outlined, size: 18),
                  label: const Text('Report Issue'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () {}, icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Received'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Order #$orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('27 May 2026 · 2 items', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: const Text('Out for Delivery', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.map_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 8),
          const Text('Live Map Tracking', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          const Text('ETA: 25 minutes', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ]),
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = [
      {'title': 'Order Placed', 'time': '27 May, 10:30 AM', 'done': true, 'icon': Icons.receipt_long},
      {'title': 'Payment Confirmed', 'time': '27 May, 10:31 AM', 'done': true, 'icon': Icons.payment},
      {'title': 'Processing', 'time': '27 May, 11:00 AM', 'done': true, 'icon': Icons.inventory_2},
      {'title': 'Shipped', 'time': '27 May, 02:15 PM', 'done': true, 'icon': Icons.local_shipping},
      {'title': 'Out for Delivery', 'time': '27 May, 04:30 PM', 'done': true, 'icon': Icons.delivery_dining},
      {'title': 'Delivered', 'time': 'Pending', 'done': false, 'icon': Icons.check_circle},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            final done = s['done'] as bool;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: done ? AppColors.success : AppColors.grey300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(s['icon'] as IconData, size: 16, color: done ? Colors.white : AppColors.textSecondary),
                  ),
                  if (i < steps.length - 1) Container(width: 2, height: 36, color: done ? AppColors.success : AppColors.grey300),
                ]),
                const SizedBox(width: 14),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s['title'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: done ? AppColors.textPrimary : AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(s['time'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                )),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCourierInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: const Icon(Icons.person, color: AppColors.primary)),
          const SizedBox(width: 14),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ahmad Kurniawan', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('JNE Express · B 1234 XYZ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone, color: AppColors.primary)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...List.generate(2, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey400, size: 24)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(i == 0 ? 'Classic Leather Bag' : 'Diamond Watch', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('Qty: 1', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              Text(i == 0 ? 'Rp 12.5M' : 'Rp 45.0M', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ]),
          )),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('Rp 57,500,000', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
          ]),
        ],
      ),
    );
  }
}