import 'package:flutter/material.dart';
import 'package:velvoria/core/theme/app_colors.dart';
import 'package:velvoria/core/utils/currency.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Velvoria Official Store', 'msg': 'Pesanan Anda sudah dikemas! 📦', 'time': '2m', 'unread': 2, 'online': true},
      {'name': 'Aurelia Boutique', 'msg': 'Ya, kami punya ukuran M yang tersedia', 'time': '1j', 'unread': 0, 'online': true},
      {'name': 'Maison Vela Gallery', 'msg': 'Terima kasih atas pembelian Anda!', 'time': '3j', 'unread': 0, 'online': false},
      {'name': 'Dukungan Pelanggan', 'msg': 'Ada lagi yang bisa kami bantu?', 'time': '1h', 'unread': 1, 'online': true},
      {'name': 'Noir & Co Store', 'msg': 'Barang akan tersedia lagi minggu depan', 'time': '2h', 'unread': 0, 'online': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pesan', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.search, color: AppColors.textPrimary), onPressed: () {})],
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 80, color: AppColors.grey200),
        itemBuilder: (_, i) {
          final c = chats[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(radius: 26, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Text((c['name'] as String)[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18))),
                if (c['online'] as bool) Positioned(bottom: 0, right: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
              ],
            ),
            title: Row(children: [
              Expanded(child: Text(c['name'] as String, style: TextStyle(fontWeight: (c['unread'] as int) > 0 ? FontWeight.bold : FontWeight.w500, fontSize: 15))),
              Text(c['time'] as String, style: TextStyle(fontSize: 12, color: (c['unread'] as int) > 0 ? AppColors.primary : AppColors.textSecondary)),
            ]),
            subtitle: Row(children: [
              Expanded(child: Text(c['msg'] as String, style: TextStyle(fontSize: 13, color: (c['unread'] as int) > 0 ? AppColors.textPrimary : AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if ((c['unread'] as int) > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)), child: Text('${c['unread']}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
            ]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailPage(sellerName: c['name'] as String))),
          );
        },
      ),
    );
  }
}

class ChatDetailPage extends StatefulWidget {
  final String sellerName;
  const ChatDetailPage({super.key, required this.sellerName});
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _controller = TextEditingController();
  final _messages = <Map<String, dynamic>>[
    {'text': 'Halo, apakah Tas Kulit Klasik masih tersedia warna cokelat?', 'isMe': true, 'time': '10.30'},
    {'text': 'Halo! Ya, masih tersedia warna cokelat. Apakah Anda ingin melihat foto lainnya?', 'isMe': false, 'time': '10.32'},
    {'text': 'Boleh dong! Lalu, berapa lama pengiriman ke Jakarta?', 'isMe': true, 'time': '10.33'},
    {'text': 'Ini beberapa foto tambahan. Pengiriman ke Jakarta 2-3 hari kerja dengan JNE Express.', 'isMe': false, 'time': '10.35'},
    {'text': 'Pesanan Anda sudah dikemas! 📦', 'isMe': false, 'time': '14.15'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Text(widget.sellerName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.sellerName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const Text('Online', style: TextStyle(fontSize: 11, color: AppColors.success)),
            ]),
          ),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Kartu konteks produk
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.grey200)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shopping_bag_outlined, size: 22, color: AppColors.grey400)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Tas Kulit Klasik', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(Currency.idr(12500000), style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ])),
              const Icon(Icons.chevron_right, color: AppColors.grey400),
            ]),
          ),
          // Pesan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildMessage(_messages[i]),
            ),
          ),
          // Balasan cepat
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['Masih tersedia?', 'Berapa harganya?', 'Lama pengiriman?', 'Bisa nego?'].map((q) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(label: Text(q, style: const TextStyle(fontSize: 11)), backgroundColor: Colors.white, side: const BorderSide(color: AppColors.grey300), onPressed: () => setState(() { _controller.text = q; })),
              )).toList(),
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))]),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.add_circle_outline, color: AppColors.primary), onPressed: () {}),
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(24)),
                child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Tulis pesan...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 14))),
              )),
              const SizedBox(width: 8),
              Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() { _messages.add({'text': _controller.text, 'isMe': true, 'time': 'Sekarang'}); _controller.clear(); });
                  }
                }),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> m) {
    final isMe = m['isMe'] as bool;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4), bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(m['text'] as String, style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary, fontSize: 14)),
          const SizedBox(height: 4),
          Text(m['time'] as String, style: TextStyle(fontSize: 10, color: isMe ? Colors.white.withValues(alpha: 0.7) : AppColors.grey500)),
        ]),
      ),
    );
  }
}
