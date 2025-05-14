import 'package:flutter/material.dart';
import 'package:linux_cart/providers/cart_provider.dart';
import 'package:linux_cart/providers/products_provider.dart';
import 'package:linux_cart/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key}); // Конструктор оставляем как есть

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef теперь будет распознан
    final products = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isInCart = cart.any((item) => item.product.id == product.id);

          return ProductCard(
            product: product,
            isInCart: isInCart,
          );
        },
      ),
    );
  }
}
