import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';
import 'package:linux_cart/providers/dio_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linux_cart/api/cart_api.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  final Ref ref;
  final int customerId; // Assume you have a customer ID

  CartNotifier(this.ref, this.customerId) : super([]) {
    loadCart();
  }

  CartApi get _cartApi => ref.read(cartApiProvider);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadCart() async {
    try {
      final items = await _cartApi.getCartItems(customerId);
      state = items;
    } catch (e) {
      // Handle error
    }
  }

  double get totalPrice {
    return state.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  Future<void> addToCart(Product product) async {
    try {
      final existingIndex =
          state.indexWhere((item) => item.product.id == product.id);

      if (existingIndex >= 0) {
        // Item exists, increment quantity
        await incrementQuantity(product.id);
      } else {
        // Add new item
        await _cartApi.addToCart(customerId, product.id, 1);
        await loadCart(); // Refresh cart from backend
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> incrementQuantity(int productId) async {
    try {
      final item = state.firstWhere((item) => item.product.id == productId);
      await _cartApi.updateQuantity(customerId, productId, item.quantity + 1);
      await loadCart();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> decrementQuantity(int productId) async {
    try {
      final item = state.firstWhere((item) => item.product.id == productId);
      if (item.quantity > 1) {
        await _cartApi.updateQuantity(customerId, productId, item.quantity - 1);
      } else {
        await removeFromCart(productId);
      }
      await loadCart();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await _cartApi.removeFromCart(customerId, productId);
      await loadCart();
    } catch (e) {
      // Handle error
    }
  }
}

final cartApiProvider = Provider<CartApi>((ref) {
  final dio = ref.read(dioProvider); // You might need to create a dioProvider
  return CartApi(dio);
});

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  // You need to provide customerId here - could be from auth provider
  const customerId = 1; // Replace with actual customer ID
  return CartNotifier(ref, customerId);
});
