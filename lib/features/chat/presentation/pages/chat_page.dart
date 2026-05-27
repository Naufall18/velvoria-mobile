import 'package:flutter/material.dart';
import 'package:luxemart/core/theme/app_colors.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'LUXE Official Store', 'msg': 'Your order has been packaged! 📦', 'time': '2m', 'unread': 2, 'online': true},
      {'name': 'Gucci Boutique', 'msg': 'Yes, we have size M available', 'time': '1h', 'unread': 0, 'online': true},
      {'name': 'Hermès Gallery', 'msg': 'Thank you for your purchase!', 'time': '3h', 'unread': 0, 'online': false},
      {'name': 'Customer Support', 'msg': 'Is there anything else I can help with?', 'time': '1d', 'unread': 1, 'online': true},
      {'name': 'Prada Store', 'msg': 'The item will be restocked next week', 'time': '2d', 'unread': 0, 'online': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('Messages', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.search, color: AppColors.textPrimary), onPressed: () {})],
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => Divider(height: 1, indent: 80, color: AppColors.grey200),
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
    {'text': 'Hi, is the Classic Leather Bag still available in brown?', 'isMe': true, 'time': '10:30 AM'},
    {'text': 'Hello! Yes, we still have it in brown. Would you like to see more photos?', 'isMe': false, 'time': '10:32 AM'},
    {'text': 'Yes please! Also, what\'s the delivery time to Jakarta?', 'isMe': true, 'time': '10:33 AM'},
    {'text': 'Here are some additional photos. Delivery to Jakarta is 2-3 business days with JNE Express.', 'isMe': false, 'time': '10:35 AM'},
    {'text': 'Your order has been packaged! 📦', 'isMe': false, 'time': '2:15 PM'},
  ];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Text(widget.sellerName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.sellerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const Text('Online', style: TextStyle(fontSize: 11, color: AppColors.success)),
          ]),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Product context card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.grey200)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.shopping_bag_outlined, size: 22, color: AppColors.grey400)),
              const SizedBox(width: 10),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Classic Leather Bag', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('Rp 12,500,000', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ])),
              const Icon(Icons.chevron_right, color: AppColors.grey400),
            ]),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildMessage(_messages[i]),
            ),
          ),
          // Quick replies
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['Is this available?', 'What\'s the price?', 'Delivery time?', 'Can I negotiate?'].map((q) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(label: Text(q, style: const TextStyle(fontSize: 11)), backgroundColor: Colors.white, side: BorderSide(color: AppColors.grey300), onPressed: () => setState(() { _controller.text = q; })),
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
                child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 14))),
              )),
              const SizedBox(width: 8),
              Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() { _messages.add({'text': _controller.text, 'isMe': true, 'time': 'Now'}); _controller.clear(); });
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