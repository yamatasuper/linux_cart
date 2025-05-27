import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';

// api/cart_api.dart
import 'package:dio/dio.dart';

class CartApi {
  final Dio _dio;

  CartApi(this._dio);

  Future<List<CartItem>> getCartItems(int customerId) async {
    try {
      final response = await _dio.get('/api/carts/$customerId');
      final cartData = response.data;

      final items = (cartData['items'] as List).map((item) {
        // Create a Product object from the item data
        final product = Product(
          id: item['productId'],
          name: item['productName'],
          price: item['price'] is int
              ? (item['price'] as int).toDouble()
              : (item['price'] as num).toDouble(),
          quantity: 0, // This might not be needed for cart items
          currency: item['currency'],
          imageUrl: item['imageUrl'],
        );

        return CartItem(
          product: product,
          quantity: item['quantity'],
        );
      }).toList();

      return items;
    } on DioException catch (e) {
      throw Exception('Failed to load cart: ${e.message}');
    }
  }

  Future<void> addToCart(int customerId, int productId, int quantity) async {
    try {
      await _dio.post(
        '/api/carts/$customerId/items',
        data: {'productId': productId, 'quantity': quantity},
      );
    } on DioException catch (e) {
      throw Exception('Failed to add to cart: ${e.message}');
    }
  }

  Future<void> updateQuantity(
      int customerId, int productId, int quantity) async {
    try {
      await _dio.put(
        '/api/carts/$customerId/items/$productId',
        queryParameters: {'quantity': quantity},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update quantity: ${e.message}');
    }
  }

  Future<void> removeFromCart(int customerId, int productId) async {
    try {
      await _dio.delete('/api/carts/$customerId/items/$productId');
    } on DioException catch (e) {
      throw Exception('Failed to remove from cart: ${e.message}');
    }
  }
}
