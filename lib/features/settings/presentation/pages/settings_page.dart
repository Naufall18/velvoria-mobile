import 'package:flutter/material.dart';
import 'package:velvoria/core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifOrders = true;
  bool _notifPromos = true;
  bool _notifUpdates = false;
  bool _biometric = true;
  bool _dataSaver = false;
  String _language = 'Bahasa Indonesia';
  String _currency = 'IDR (Rp)';

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
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Akun', [
            _navItem(Icons.person_outline, 'Edit Profil'),
            _navItem(Icons.lock_outline, 'Ubah Kata Sandi'),
            _navItem(Icons.security, 'Autentikasi Dua Faktor'),
            _toggleItem(Icons.fingerprint, 'Login Biometrik', _biometric,
                (v) => setState(() => _biometric = v)),
          ]),
          _section('Notifikasi', [
            _toggleItem(Icons.shopping_bag_outlined, 'Pembaruan Pesanan',
                _notifOrders, (v) => setState(() => _notifOrders = v)),
            _toggleItem(Icons.local_offer_outlined, 'Promo', _notifPromos,
                (v) => setState(() => _notifPromos = v)),
            _toggleItem(Icons.campaign_outlined, 'Pembaruan Aplikasi',
                _notifUpdates, (v) => setState(() => _notifUpdates = v)),
          ]),
          _section('Preferensi', [
            _toggleItem(Icons.dark_mode_outlined, 'Mode Gelap', _darkMode,
                (v) => setState(() => _darkMode = v)),
            _toggleItem(Icons.data_saver_on_outlined, 'Hemat Data', _dataSaver,
                (v) => setState(() => _dataSaver = v)),
            _dropdownItem(Icons.language, 'Bahasa', _language,
                const ['Bahasa Indonesia', 'English', '日本語'],
                (v) => setState(() => _language = v)),
            _dropdownItem(Icons.payments_outlined, 'Mata Uang', _currency,
                const ['IDR (Rp)', 'USD (\$)', 'EUR (€)'],
                (v) => setState(() => _currency = v)),
          ]),
          _section('Privasi & Keamanan', [
            _navItem(Icons.privacy_tip_outlined, 'Pengaturan Privasi'),
            _navItem(Icons.history, 'Aktivitas Login'),
            _navItem(Icons.devices, 'Perangkat Terhubung'),
          ]),
          _section('Tentang', [
            _navItem(Icons.description_outlined, 'Syarat & Ketentuan'),
            _navItem(Icons.policy_outlined, 'Kebijakan Privasi'),
            _navItem(Icons.info_outline, 'Tentang Velvoria'),
            _navItem(Icons.help_outline, 'Pusat Bantuan'),
          ]),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 12, color: AppColors.grey500),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hapus Akun'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _navItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400, size: 20),
      dense: true,
      onTap: () {},
    );
  }

  Widget _toggleItem(
      IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
      dense: true,
    );
  }

  Widget _dropdownItem(IconData icon, String title, String value,
      List<String> options, ValueChanged<String> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
      dense: true,
    );
  }
}
