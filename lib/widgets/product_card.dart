import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';
import 'package:linux_cart/providers/cart_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final bool isInCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          Expanded(
              child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error_outline, color: Colors.red);
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('\$${product.price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildAddToCartButton(ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(WidgetRef ref) {
    if (!isInCart) {
      return ElevatedButton(
        onPressed: () => ref.read(cartProvider.notifier).addToCart(product),
        child: const Text('Добавить в корзину'),
      );
    }

    final cartItem = ref.watch(cartProvider).firstWhere(
          (item) => item.product.id == product.id,
          orElse: () => CartItem(product: product, quantity: 0),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () =>
              ref.read(cartProvider.notifier).decrementQuantity(product.id),
        ),
        Text(cartItem.quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () =>
              ref.read(cartProvider.notifier).incrementQuantity(product.id),
        ),
      ],
    );
  }
}
