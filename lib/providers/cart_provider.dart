import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';
import 'package:riverpod/riverpod.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state[index].quantity++;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void incrementQuantity(String productId) {
    state = state.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }

  void decrementQuantity(String productId) {
    state = state
        .map((item) {
          if (item.product.id == productId) {
            final newQuantity = item.quantity - 1;
            return CartItem(product: item.product, quantity: newQuantity);
          }
          return item;
        })
        .where((item) => item.quantity > 0)
        .toList();
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
