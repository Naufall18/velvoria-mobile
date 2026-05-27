import 'package:flutter/material.dart';
import 'package:luxemart/core/theme/app_colors.dart';

class LiveShoppingPage extends StatelessWidget {
  const LiveShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveNow = [
      {'host': 'LUXE Official', 'title': 'Summer Collection Launch 🔥', 'viewers': '2.4K', 'products': 12},
      {'host': 'Gucci Boutique', 'title': 'Exclusive Bag Showcase', 'viewers': '1.8K', 'products': 8},
      {'host': 'Hermès Gallery', 'title': 'Scarf Styling Session', 'viewers': '956', 'products': 15},
    ];

    final upcoming = [
      {'host': 'Prada Store', 'title': 'New Season Preview', 'time': 'Today, 8:00 PM', 'reminder': false},
      {'host': 'Dior Official', 'title': 'Beauty Masterclass', 'time': 'Tomorrow, 3:00 PM', 'reminder': true},
      {'host': 'Chanel Boutique', 'title': 'Jewelry Collection', 'time': '30 May, 7:00 PM', 'reminder': false},
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
            // Live Now Section
            const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 12), child: Row(children: [
              Icon(Icons.circle, color: Colors.red, size: 10),
              SizedBox(width: 6),
              Text('Live Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text('3 streams', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
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
                            Text('${l['products']} products', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                          ]),
                        )),
                      ]),
                    ),
                  );
                },
              ),
            ),
            // Upcoming
            const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 12), child: Text('Upcoming', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ...upcoming.map((u) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
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
            // Replays
            const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 12), child: Text('Replays', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
              itemCount: 4,
              itemBuilder: (_, i) {
                final replays = ['Flash Sale Highlights', 'Watch Collection', 'Bag Authentication', 'Style Tips'];
                final views = ['15K', '8.2K', '12K', '5.6K'];
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary.withValues(alpha: 0.06)),
                  child: Stack(children: [
                    Center(child: Icon(Icons.play_circle_filled, size: 44, color: AppColors.primary.withValues(alpha: 0.3))),
                    Positioned(top: 8, right: 8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4)),
                      child: Text('${views[i]} views', style: const TextStyle(color: Colors.white, fontSize: 9)),
                    )),
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        color: Colors.white,
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(replays[i], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text('2 days ago', style: TextStyle(fontSize: 10, color: AppColors.grey500)),
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
            // Video placeholder
            Center(child: Icon(Icons.videocam, size: 80, color: Colors.white.withValues(alpha: 0.2))),
            // Top bar
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
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
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
            // Right side actions
            Positioned(right: 12, bottom: 200, child: Column(children: [
              _actionBtn(Icons.favorite, 'Like', '1.2K'),
              _actionBtn(Icons.chat_bubble, 'Chat', '856'),
              _actionBtn(Icons.share, 'Share', ''),
              _actionBtn(Icons.card_giftcard, 'Gift', ''),
            ])),
            // Product showcase at bottom
            Positioned(bottom: 0, left: 0, right: 0, child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent])),
              child: Column(children: [
                // Chat messages
                ...['Amazing! 😍', 'How much is this?', 'I want the blue one!'].map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    CircleAvatar(radius: 12, backgroundColor: Colors.white.withValues(alpha: 0.2), child: const Icon(Icons.person, size: 12, color: Colors.white)),
                    const SizedBox(width: 8),
                    Text(m, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                  ]),
                )),
                const SizedBox(height: 8),
                // Featured product
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey400)),
                    const SizedBox(width: 10),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Classic Leather Bag', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('Rp 12,500,000', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
                    ])),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Buy', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
                // Chat input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(24)),
                  child: const TextField(
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(hintText: 'Say something...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none, suffixIcon: Icon(Icons.send, color: Colors.white54, size: 20)),
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