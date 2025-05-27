import 'package:linux_cart/api/product_api.dart';
import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';
import 'package:linux_cart/providers/cart_provider.dart';
import 'package:riverpod/riverpod.dart';

// providers/products_provider.dart
final productApiProvider = Provider<ProductApi>((ref) => ProductApi());

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(productApiProvider);
  return await api.fetchProducts();
});
