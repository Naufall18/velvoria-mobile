import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Pusat Bantuan dengan kategori FAQ, pencarian, dan opsi kontak.
class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final _searchController = TextEditingController();
  int _expandedFaq = -1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildCategoryGrid(),
          const SizedBox(height: 28),
          _buildFaqSection(),
          const SizedBox(height: 28),
          _buildContactSection(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari bantuan...',
          hintStyle: const TextStyle(color: AppColors.grey400, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    const categories = [
      _HelpCategory(Icons.shopping_bag_rounded, 'Pesanan', AppColors.info),
      _HelpCategory(Icons.payment_rounded, 'Pembayaran', AppColors.success),
      _HelpCategory(Icons.local_shipping_rounded, 'Pengiriman', AppColors.secondary),
      _HelpCategory(Icons.assignment_return_rounded, 'Pengembalian', AppColors.error),
      _HelpCategory(Icons.account_circle_rounded, 'Akun', AppColors.accent),
      _HelpCategory(Icons.security_rounded, 'Keamanan', AppColors.primary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Telusuri berdasarkan Topik',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final cat = categories[i];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(cat.icon, size: 22, color: cat.color),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat.label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFaqSection() {
    const faqs = [
      _FaqItem(
        'Bagaimana cara melacak pesanan saya?',
        'Buka "Pesanan Saya" di profil Anda, pilih pesanan, lalu ketuk "Lacak Pesanan". Anda dapat melihat status terkini dan perkiraan waktu pengiriman secara langsung.',
      ),
      _FaqItem(
        'Apa kebijakan pengembalian Velvoria?',
        'Kami menawarkan kebijakan pengembalian 14 hari untuk semua barang dalam kondisi asli. Barang mewah memenuhi syarat untuk pengembalian gratis dengan label pengiriman premium kami.',
      ),
      _FaqItem(
        'Bagaimana cara memverifikasi keaslian produk?',
        'Setiap produk di Velvoria dilengkapi sertifikat keaslian. Anda dapat memindai kode QR pada sertifikat untuk memverifikasinya melalui sistem verifikasi berbasis blockchain kami.',
      ),
      _FaqItem(
        'Bagaimana cara menjadi penjual?',
        'Buka Pengaturan > Jadi Penjual. Selesaikan proses verifikasi termasuk dokumen usaha dan verifikasi identitas. Persetujuan biasanya memakan waktu 2-3 hari kerja.',
      ),
      _FaqItem(
        'Metode pembayaran apa saja yang diterima?',
        'Kami menerima kartu Kredit/Debit (Visa, Mastercard, Amex), dompet digital (GoPay, OVO, Dana), transfer bank, cicilan, dan Bayar di Tempat (COD).',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pertanyaan yang Sering Diajukan',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 14),
        ...List.generate(faqs.length, (i) {
          final faq = faqs[i];
          final isExpanded = _expandedFaq == i;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isExpanded ? AppColors.accent : AppColors.grey200,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  title: Text(
                    faq.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  trailing: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more_rounded, color: AppColors.grey500),
                  ),
                  onTap: () => setState(() => _expandedFaq = isExpanded ? -1 : i),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq.answer,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Masih Butuh Bantuan?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 14),
        _buildContactTile(
          Icons.chat_bubble_rounded,
          'Obrolan Langsung',
          'Ngobrol dengan tim dukungan kami',
          AppColors.accent,
        ),
        _buildContactTile(
          Icons.email_rounded,
          'Dukungan Email',
          'support@velvoria.com',
          AppColors.info,
        ),
        _buildContactTile(
          Icons.phone_rounded,
          'Telepon Kami',
          '+62 21 1234 5678 (09.00 - 21.00)',
          AppColors.success,
        ),
        _buildContactTile(
          Icons.message_rounded,
          'WhatsApp',
          '+62 812 0000 1234',
          AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildContactTile(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
      ),
    );
  }
}

class _HelpCategory {
  final IconData icon;
  final String label;
  final Color color;
  const _HelpCategory(this.icon, this.label, this.color);
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}
