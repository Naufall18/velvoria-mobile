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
  String _language = 'English';
  String _currency = 'IDR (Rp)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('Settings', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Account', [
            _navItem(Icons.person_outline, 'Edit Profile'),
            _navItem(Icons.lock_outline, 'Change Password'),
            _navItem(Icons.security, 'Two-Factor Authentication'),
            _toggleItem(Icons.fingerprint, 'Biometric Login', _biometric, (v) => setState(() => _biometric = v)),
          ]),
          _section('Notifications', [
            _toggleItem(Icons.shopping_bag_outlined, 'Order Updates', _notifOrders, (v) => setState(() => _notifOrders = v)),
            _toggleItem(Icons.local_offer_outlined, 'Promotions', _notifPromos, (v) => setState(() => _notifPromos = v)),
            _toggleItem(Icons.campaign_outlined, 'App Updates', _notifUpdates, (v) => setState(() => _notifUpdates = v)),
          ]),
          _section('Preferences', [
            _toggleItem(Icons.dark_mode_outlined, 'Dark Mode', _darkMode, (v) => setState(() => _darkMode = v)),
            _toggleItem(Icons.data_saver_on_outlined, 'Data Saver', _dataSaver, (v) => setState(() => _dataSaver = v)),
            _dropdownItem(Icons.language, 'Language', _language, ['English', 'Bahasa Indonesia', '日本語'], (v) => setState(() => _language = v)),
            _dropdownItem(Icons.attach_money, 'Currency', _currency, ['IDR (Rp)', 'USD (\$)', 'EUR (€)'], (v) => setState(() => _currency = v)),
          ]),
          _section('Privacy & Security', [
            _navItem(Icons.privacy_tip_outlined, 'Privacy Settings'),
            _navItem(Icons.history, 'Login Activity'),
            _navItem(Icons.devices, 'Connected Devices'),
          ]),
          _section('About', [
            _navItem(Icons.description_outlined, 'Terms of Service'),
            _navItem(Icons.policy_outlined, 'Privacy Policy'),
            _navItem(Icons.info_outline, 'About Velvoria'),
            _navItem(Icons.help_outline, 'Help Center'),
          ]),
          const SizedBox(height: 16),
          Center(child: Text('Version 1.0.0', style: TextStyle(fontSize: 12, color: AppColors.grey500))),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Delete Account'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(bottom: 8, top: 8), child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(children: children)),
      const SizedBox(height: 12),
    ]);
  }

  Widget _navItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400, size: 20),
      dense: true, onTap: () {},
    );
  }

  Widget _toggleItem(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
      dense: true,
    );
  }

  Widget _dropdownItem(IconData icon, String title, String value, List<String> options, ValueChanged<String> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: DropdownButton<String>(
        value: value, underline: const SizedBox(), style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
      dense: true,
    );
  }
}
