import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Address management screen - list, add, edit, delete addresses.
class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  int _defaultIndex = 0;

  final _addresses = const [
    _AddressData(
      label: 'Home',
      icon: Icons.home_rounded,
      name: 'John Doe',
      phone: '+62 812 3456 7890',
      address: 'Jl. Sudirman No. 123, Lantai 5\nJakarta Selatan, DKI Jakarta 12190',
    ),
    _AddressData(
      label: 'Office',
      icon: Icons.business_rounded,
      name: 'John Doe',
      phone: '+62 812 3456 7890',
      address: 'Gedung Wisma 46, Jl. Jend. Sudirman Kav. 1\nJakarta Pusat, DKI Jakarta 10220',
    ),
    _AddressData(
      label: 'Parents',
      icon: Icons.family_restroom_rounded,
      name: 'Robert Doe',
      phone: '+62 811 2233 4455',
      address: 'Jl. Diponegoro No. 45\nBandung, Jawa Barat 40115',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...List.generate(_addresses.length, (i) => _buildAddressCard(i)),
          const SizedBox(height: 16),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildAddressCard(int index) {
    final addr = _addresses[index];
    final isDefault = index == _defaultIndex;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColors.accent : AppColors.grey200,
          width: isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDefault
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  addr.icon,
                  size: 18,
                  color: isDefault ? AppColors.accent : AppColors.grey500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      addr.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.grey500),
                onSelected: (value) {
                  if (value == 'default') {
                    setState(() => _defaultIndex = index);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (!isDefault)
                    const PopupMenuItem(value: 'default', child: Text('Set as Default')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Name & phone
          Text(
            addr.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            addr.phone,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),

          // Address
          Text(
            addr.address,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to add address form
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200, style: BorderStyle.solid),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded, color: AppColors.accent, size: 22),
            SizedBox(width: 8),
            Text(
              'Add New Address',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for address items.
class _AddressData {
  final String label;
  final IconData icon;
  final String name;
  final String phone;
  final String address;

  const _AddressData({
    required this.label,
    required this.icon,
    required this.name,
    required this.phone,
    required this.address,
  });
}
