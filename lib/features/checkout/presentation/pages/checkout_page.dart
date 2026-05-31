import 'package:flutter/material.dart';
import 'package:velvoria/core/theme/app_colors.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  int _selectedAddress = 0;
  int _selectedDelivery = 1;
  int _selectedPayment = 0;
  bool _giftWrap = false;
  bool _agreedTerms = false;

  final _addresses = [
    {'label': 'Home', 'address': 'Jl. Sudirman No. 123, Jakarta Selatan, 12190', 'phone': '+62 812-3456-7890'},
    {'label': 'Office', 'address': 'Jl. Thamrin No. 456, Jakarta Pusat, 10350', 'phone': '+62 813-9876-5432'},
  ];

  final _deliveryOptions = [
    {'name': 'Same Day', 'desc': 'Today before 9 PM', 'price': 50000, 'icon': Icons.bolt},
    {'name': 'Express', 'desc': '1-2 business days', 'price': 25000, 'icon': Icons.local_shipping},
    {'name': 'Standard', 'desc': '3-5 business days', 'price': 10000, 'icon': Icons.inventory_2},
    {'name': 'Pickup Point', 'desc': 'Pick up at nearest point', 'price': 0, 'icon': Icons.storefront},
  ];

  final _paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card, 'desc': '**** 4532'},
    {'name': 'GoPay', 'icon': Icons.account_balance_wallet, 'desc': 'Balance: Rp 500,000'},
    {'name': 'Bank Transfer', 'icon': Icons.account_balance, 'desc': 'BCA, Mandiri, BNI'},
    {'name': 'Installment', 'icon': Icons.calendar_month, 'desc': '0% up to 12 months'},
    {'name': 'COD', 'icon': Icons.money, 'desc': 'Cash on Delivery'},
  ];

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
        title: const Text('Checkout', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _currentStep == 0
                  ? _buildShippingStep()
                  : _currentStep == 1
                      ? _buildPaymentStep()
                      : _buildReviewStep(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ['Shipping', 'Payment', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (i) {
          final active = i <= _currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.grey300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: i < _currentStep
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text('${i + 1}', style: TextStyle(color: active ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6),
                Text(steps[i], style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.w600 : FontWeight.normal, color: active ? AppColors.primary : AppColors.textSecondary)),
                if (i < steps.length - 1)
                  Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: i < _currentStep ? AppColors.primary : AppColors.grey300)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShippingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Shipping Address'),
        ..._addresses.asMap().entries.map((e) {
          final i = e.key;
          final a = e.value;
          return GestureDetector(
            onTap: () => setState(() => _selectedAddress = i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _selectedAddress == i ? AppColors.primary : AppColors.grey300, width: _selectedAddress == i ? 2 : 1),
              ),
              child: Row(
                children: [
                  Radio<int>(value: i, groupValue: _selectedAddress, onChanged: (v) => setState(() => _selectedAddress = v!), activeColor: AppColors.primary),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(a['label']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary))),
                        ]),
                        const SizedBox(height: 6),
                        Text(a['address']!, style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(a['phone']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 48)),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Delivery Method'),
        ..._deliveryOptions.asMap().entries.map((e) {
          final i = e.key;
          final d = e.value;
          return GestureDetector(
            onTap: () => setState(() => _selectedDelivery = i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _selectedDelivery == i ? AppColors.primary : AppColors.grey300),
              ),
              child: Row(
                children: [
                  Icon(d['icon'] as IconData, color: _selectedDelivery == i ? AppColors.primary : AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(d['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                  Text(d['price'] as int == 0 ? 'FREE' : 'Rp ${((d['price'] as int) / 1000).toStringAsFixed(0)}K', style: TextStyle(fontWeight: FontWeight.bold, color: d['price'] as int == 0 ? AppColors.success : AppColors.primary)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.card_giftcard, color: AppColors.secondary),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Gift Wrap', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('Premium packaging + Rp 25,000', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              Switch(value: _giftWrap, onChanged: (v) => setState(() => _giftWrap = v), activeThumbColor: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Payment Method'),
        ..._paymentMethods.asMap().entries.map((e) {
          final i = e.key;
          final p = e.value;
          return GestureDetector(
            onTap: () => setState(() => _selectedPayment = i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _selectedPayment == i ? AppColors.primary : AppColors.grey300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                    child: Icon(p['icon'] as IconData, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(p['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                  Radio<int>(value: i, groupValue: _selectedPayment, onChanged: (v) => setState(() => _selectedPayment = v!), activeColor: AppColors.primary),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _sectionTitle('Promo Code'),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Enter promo code', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 14)))),
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Apply', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Order Summary'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ...List.generate(2, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey400)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(i == 0 ? 'Classic Leather Bag' : 'Diamond Watch', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('Qty: 1 · Size: M', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ])),
                    Text(i == 0 ? 'Rp 12.5M' : 'Rp 45.0M', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionTitle('Shipping'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_addresses[_selectedAddress]['label']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_addresses[_selectedAddress]['address']!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const Divider(height: 20),
              Text('${_deliveryOptions[_selectedDelivery]['name']} · ${_deliveryOptions[_selectedDelivery]['desc']}', style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionTitle('Price Breakdown'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _priceRow('Subtotal', 'Rp 57,500,000'),
              _priceRow('Shipping', 'Rp 25,000'),
              _priceRow('Gift Wrap', _giftWrap ? 'Rp 25,000' : '-'),
              _priceRow('Discount', '-Rp 2,875,000', isDiscount: true),
              const Divider(height: 20),
              _priceRow('Total', 'Rp 54,675,000', isTotal: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(value: _agreedTerms, onChanged: (v) => setState(() => _agreedTerms = v!), activeColor: AppColors.primary),
            const Expanded(child: Text('I agree to the Terms & Conditions and Privacy Policy', style: TextStyle(fontSize: 12))),
          ],
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, color: isDiscount ? AppColors.success : isTotal ? AppColors.primary : AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _currentStep == 2 && !_agreedTerms ? null : () {
                if (_currentStep < 2) {
                  setState(() => _currentStep++);
                } else {
                  _showOrderSuccess();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(_currentStep == 2 ? 'Place Order' : 'Continue', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              const Text('Order Placed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Order #LXM-2026-0001', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              const Text('Estimated delivery: 29 May 2026', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Track Order', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Continue Shopping')),
            ],
          ),
        ),
      ),
    );
  }
}
