import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cart item model
class CartItem {
  final String id;
  final String name;
  final String brand;
  final String price;
  final String imageIcon;
  final int quantity;
  final String? variant;

  const CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.imageIcon = 'bag',
    this.quantity = 1,
    this.variant,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      brand: brand,
      price: price,
      imageIcon: imageIcon,
      quantity: quantity ?? this.quantity,
      variant: variant,
    );
  }
}

/// Cart state
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? promoCode;
  final double discount;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.promoCode,
    this.discount = 0,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? promoCode,
    double? discount,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
    );
  }
}

/// Cart state notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(CartItem item) {
    final existingIndex = state.items.indexWhere((e) => e.id == item.id);
    if (existingIndex >= 0) {
      final updated = [...state.items];
      updated[existingIndex] = updated[existingIndex]
          .copyWith(quantity: updated[existingIndex].quantity + 1);
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((e) => e.id != id).toList(),
    );
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    final updated = state.items.map((item) {
      return item.id == id ? item.copyWith(quantity: quantity) : item;
    }).toList();
    state = state.copyWith(items: updated);
  }

  void applyPromoCode(String code) {
    // Simulated promo logic
    state = state.copyWith(promoCode: code, discount: 10.0);
  }

  void clearCart() {
    state = const CartState();
  }
}

/// Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});