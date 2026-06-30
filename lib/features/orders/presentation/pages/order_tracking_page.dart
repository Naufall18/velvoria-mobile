import 'package:flutter/material.dart';
import 'package:velvoria/core/theme/app_colors.dart';
import 'package:velvoria/core/utils/currency.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;
  const OrderTrackingPage({super.key, this.orderId = 'LXM-2026-0001'});

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
        title: const Text('Lacak Pesanan', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
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
                  label: const Text('Laporkan Masalah'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () {}, icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Diterima'),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pesanan #$orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('27 Mei 2026 · 2 barang', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: const Text('Dikirim', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600, fontSize: 12)),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.map_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 8),
          const Text('Pelacakan Peta Langsung', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          const Text('Estimasi tiba: 25 menit', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ]),
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = [
      {'title': 'Pesanan Dibuat', 'time': '27 Mei, 10.30', 'done': true, 'icon': Icons.receipt_long},
      {'title': 'Dikonfirmasi', 'time': '27 Mei, 10.31', 'done': true, 'icon': Icons.payment},
      {'title': 'Diproses', 'time': '27 Mei, 11.00', 'done': true, 'icon': Icons.inventory_2},
      {'title': 'Dikirim', 'time': '27 Mei, 14.15', 'done': true, 'icon': Icons.local_shipping},
      {'title': 'Dalam Pengantaran', 'time': '27 Mei, 16.30', 'done': true, 'icon': Icons.delivery_dining},
      {'title': 'Tiba di Tujuan', 'time': 'Menunggu', 'done': false, 'icon': Icons.check_circle},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Riwayat Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    Text(s['time'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Barang Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...List.generate(2, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey400, size: 24)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(i == 0 ? 'Tas Kulit Klasik' : 'Jam Tangan Berlian', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const Text('Jumlah: 1', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              Text(Currency.idr(i == 0 ? 12500000 : 45000000), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ]),
          )),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(Currency.idr(57500000), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
          ]),
        ],
      ),
    );
  }
}
