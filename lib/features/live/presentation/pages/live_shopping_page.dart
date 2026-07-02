import 'package:flutter/material.dart';
import 'package:velvoria/core/theme/app_colors.dart';
import 'package:velvoria/core/utils/currency.dart';

class LiveShoppingPage extends StatelessWidget {
  const LiveShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveNow = [
      {'host': 'Velvoria Official', 'title': 'Peluncuran Koleksi Musim Panas 🔥', 'viewers': '2.4K', 'products': 12},
      {'host': 'Aurelia Boutique', 'title': 'Pameran Tas Eksklusif', 'viewers': '1.8K', 'products': 8},
      {'host': 'Maison Vela Gallery', 'title': 'Sesi Padu Padan Syal', 'viewers': '956', 'products': 15},
    ];

    final upcoming = [
      {'host': 'Noir & Co Store', 'title': 'Pratinjau Musim Baru', 'time': 'Hari ini, 20.00', 'reminder': false},
      {'host': 'Lumen Official', 'title': 'Kelas Master Kecantikan', 'time': 'Besok, 15.00', 'reminder': true},
      {'host': 'Velour Boutique', 'title': 'Koleksi Perhiasan', 'time': '30 Mei, 19.00', 'reminder': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text('Live Shopping', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month_outlined, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Sedang Live
            const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 12), child: Row(children: [
              Icon(Icons.circle, color: AppColors.error, size: 10),
              SizedBox(width: 6),
              Text('Sedang Live', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text('3 siaran', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ])),
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: liveNow.length,
                itemBuilder: (_, i) {
                  final l = liveNow[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamView(hostName: l['host'] as String, title: l['title'] as String))),
                    child: Container(
                      width: 200, margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.primary.withValues(alpha: 0.1)),
                      child: Stack(children: [
                        Center(child: Icon(Icons.play_circle_outline, size: 56, color: AppColors.primary.withValues(alpha: 0.3))),
                        Positioned(top: 10, left: 10, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, color: Colors.white, size: 6), SizedBox(width: 4), Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))]),
                        )),
                        Positioned(top: 10, right: 10, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(6)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.visibility, color: Colors.white, size: 12), const SizedBox(width: 4), Text(l['viewers'] as String, style: const TextStyle(color: Colors.white, fontSize: 10))]),
                        )),
                        Positioned(bottom: 0, left: 0, right: 0, child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                            gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent]),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(l['host'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(l['title'] as String, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('${l['products']} produk', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                          ]),
                        )),
                      ]),
                    ),
                  );
                },
              ),
            ),
            // Akan Datang
            const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 12), child: Text('Akan Datang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ...upcoming.map((u) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.videocam_outlined, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u['host'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(u['title'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.access_time, size: 13, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(u['time'] as String, style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
                  ]),
                ])),
                IconButton(
                  icon: Icon(u['reminder'] as bool ? Icons.notifications_active : Icons.notifications_none, color: u['reminder'] as bool ? AppColors.primary : AppColors.grey400),
                  onPressed: () {},
                ),
              ]),
            )),
            // Tayangan Ulang
            const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 12), child: Text('Tayangan Ulang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
              itemCount: 4,
              itemBuilder: (_, i) {
                final replays = ['Sorotan Flash Sale', 'Koleksi Jam Tangan', 'Autentikasi Tas', 'Tips Gaya'];
                final views = ['15K', '8.2K', '12K', '5.6K'];
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary.withValues(alpha: 0.06)),
                  child: Stack(children: [
                    Center(child: Icon(Icons.play_circle_filled, size: 44, color: AppColors.primary.withValues(alpha: 0.3))),
                    Positioned(top: 8, right: 8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4)),
                      child: Text('${views[i]} tayangan', style: const TextStyle(color: Colors.white, fontSize: 9)),
                    )),
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                        color: Colors.white,
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(replays[i], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 2),
                        const Text('2 hari lalu', style: TextStyle(fontSize: 10, color: AppColors.grey500)),
                      ]),
                    )),
                  ]),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class LiveStreamView extends StatelessWidget {
  final String hostName;
  final String title;
  const LiveStreamView({super.key, required this.hostName, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Placeholder video
            Center(child: Icon(Icons.videocam, size: 80, color: Colors.white.withValues(alpha: 0.2))),
            // Bilah atas
            Positioned(top: 0, left: 0, right: 0, child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent])),
              child: Row(children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
                CircleAvatar(radius: 18, backgroundColor: Colors.white.withValues(alpha: 0.2), child: Text(hostName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(hostName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                  child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.visibility, color: Colors.white, size: 12), SizedBox(width: 4), Text('2.4K', style: TextStyle(color: Colors.white, fontSize: 10))]),
                ),
              ]),
            )),
            // Aksi sisi kanan
            Positioned(right: 12, bottom: 200, child: Column(children: [
              _actionBtn(Icons.favorite, 'Suka', '1.2K'),
              _actionBtn(Icons.chat_bubble, 'Obrolan', '856'),
              _actionBtn(Icons.share, 'Bagikan', ''),
              _actionBtn(Icons.card_giftcard, 'Hadiah', ''),
            ])),
            // Etalase produk di bawah
            Positioned(bottom: 0, left: 0, right: 0, child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent])),
              child: Column(children: [
                // Pesan obrolan
                ...['Keren banget! 😍', 'Berapa harganya?', 'Aku mau yang biru!'].map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    CircleAvatar(radius: 12, backgroundColor: Colors.white.withValues(alpha: 0.2), child: const Icon(Icons.person, size: 12, color: Colors.white)),
                    const SizedBox(width: 8),
                    Text(m, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                  ]),
                )),
                const SizedBox(height: 8),
                // Produk unggulan
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey400)),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Tas Kulit Klasik', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(Currency.idr(12500000), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
                    ])),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Beli', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
                // Input obrolan
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(24)),
                  child: const TextField(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(hintText: 'Tulis sesuatu...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none, suffixIcon: Icon(Icons.send, color: Colors.white54, size: 20)),
                  ),
                ),
              ]),
            )),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (count.isNotEmpty) ...[const SizedBox(height: 2), Text(count, style: const TextStyle(color: Colors.white, fontSize: 10))],
      ]),
    );
  }
}
