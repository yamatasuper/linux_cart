import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';
import 'package:riverpod/riverpod.dart';

// providers/cart_provider.dart
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    if (product.quantity <= 0) return;

    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state[index].quantity++;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
    state = [...state]; // Trigger update
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void incrementQuantity(int productId) {
    state = state.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }

  void decrementQuantity(int productId) {
    state = state.map((item) {
      if (item.product.id == productId && item.quantity > 1) {
        return CartItem(product: item.product, quantity: item.quantity - 1);
      }
      return item;
    }).toList();
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
