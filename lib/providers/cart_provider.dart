import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_3d/models/cart_item_model.dart';

// 1. State Definition
enum Currency { usd, ves }

class CartState {
  final List<CartItem> items;
  final Currency currency;
  final double usdToVesRate;

  CartState({
    this.items = const [],
    this.currency = Currency.usd,
    this.usdToVesRate = 36.5, // Tasa de cambio fija
  });

  double get total {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartState copyWith({List<CartItem>? items, Currency? currency}) {
    return CartState(
      items: items ?? this.items,
      currency: currency ?? this.currency,
      usdToVesRate: usdToVesRate,
    );
  }
}

// 2. Notifier Definition
class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    // Load the cart asynchronously when the provider is first read.
    _loadCart();
    // Return the initial state.
    return CartState();
  }

  static const _cartStorageKey = 'shoppingCart';

  // Business Logic Methods
  void addItem(CartItem newItem) {
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == newItem.productId,
    );

    if (existingIndex != -1) {
      // Product already in cart, increase quantity
      final updatedItems = List<CartItem>.from(state.items);
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new product
      state = state.copyWith(items: [...state.items, newItem]);
    }
    _saveCart();
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.productId != productId).toList(),
    );
    _saveCart();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final updatedItems =
        state.items.map((item) {
          if (item.productId == productId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();
    state = state.copyWith(items: updatedItems);
    _saveCart();
  }

  void clearCart() {
    state = state.copyWith(items: []);
    _saveCart();
  }

  void toggleCurrency() {
    final newCurrency =
        state.currency == Currency.usd ? Currency.ves : Currency.usd;
    state = state.copyWith(currency: newCurrency);
    // Note: Currency preference could also be saved if needed
  }

  // Persistence Logic
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = json.encode(
      state.items.map((item) => item.toMap()).toList(),
    );
    await prefs.setString(_cartStorageKey, cartJson);
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartStorageKey);
    if (cartJson != null) {
      final cartItems =
          (json.decode(cartJson) as List)
              .map((itemData) => CartItem.fromMap(itemData))
              .toList();
      state = state.copyWith(items: cartItems);
    }
  }
}

// 3. Provider Definition
final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
