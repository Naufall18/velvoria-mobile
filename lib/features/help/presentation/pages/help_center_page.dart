import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Help Center with FAQ categories, search, and contact options.
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
        title: const Text('Help Center'),
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
          hintText: 'Search for help...',
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
      _HelpCategory(Icons.shopping_bag_rounded, 'Orders', Color(0xFF4A90D9)),
      _HelpCategory(Icons.payment_rounded, 'Payments', Color(0xFF7FA99B)),
      _HelpCategory(Icons.local_shipping_rounded, 'Shipping', Color(0xFFE8B4A0)),
      _HelpCategory(Icons.assignment_return_rounded, 'Returns', Color(0xFF8B2635)),
      _HelpCategory(Icons.account_circle_rounded, 'Account', Color(0xFF2D5F5D)),
      _HelpCategory(Icons.security_rounded, 'Security', Color(0xFF1A1F3A)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse by Topic',
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
      _FaqItem('How do I track my order?', 'Go to "My Orders" in your profile, find the order, and tap "Track Order". You can see real-time status updates and estimated delivery time.'),
      _FaqItem('What is Velvoria\'s return policy?', 'We offer a 14-day return policy for all items in original condition. Luxury items are eligible for free returns with our premium shipping label.'),
      _FaqItem('How do I verify product authenticity?', 'Every product on Velvoria comes with an authenticity certificate. You can scan the QR code on the certificate to verify with our blockchain-based verification system.'),
      _FaqItem('How do I become a seller?', 'Go to Settings > Become a Seller. Complete the verification process including business documentation and identity verification. Approval typically takes 2-3 business days.'),
      _FaqItem('What payment methods are accepted?', 'We accept Credit/Debit cards (Visa, Mastercard, Amex), digital wallets (GoPay, OVO, Dana), bank transfers, installment plans, and Cash on Delivery.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
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
          'Still Need Help?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 14),
        _buildContactTile(
          Icons.chat_bubble_rounded,
          'Live Chat',
          'Chat with our support team',
          AppColors.accent,
        ),
        _buildContactTile(
          Icons.email_rounded,
          'Email Support',
          'support@Velvoria.com',
          const Color(0xFF4A90D9),
        ),
        _buildContactTile(
          Icons.phone_rounded,
          'Call Us',
          '+62 21 1234 5678 (9AM - 9PM)',
          const Color(0xFF7FA99B),
        ),
        _buildContactTile(
          Icons.message_rounded,
          'WhatsApp',
          '+62 812 0000 1234',
          const Color(0xFF25D366),
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
