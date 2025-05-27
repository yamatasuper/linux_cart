import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linux_cart/models/cart_item.dart';
import 'package:linux_cart/models/product.dart';
import 'package:linux_cart/providers/cart_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// widgets/product_card.dart
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
            child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  )
                : const Icon(Icons.image, size: 50),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: Theme.of(context).textTheme.titleLarge),
                Text('${product.price.toStringAsFixed(2)} ${product.currency}'),
                Text('Available: ${product.quantity}'),
                const SizedBox(height: 8),
                _buildAddToCartButton(ref, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Update the _buildAddToCartButton method in ProductCard
  Widget _buildAddToCartButton(WidgetRef ref, BuildContext context) {
    final isLoading = ref
        .watch(cartProvider.notifier)
        .isLoading; // You'll need to add isLoading state to your notifier

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (!isInCart) {
      return ElevatedButton(
        onPressed: () async {
          try {
            await ref.read(cartProvider.notifier).addToCart(product);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add to cart: $e')),
            );
          }
        },
        child: const Text('Add to Cart'),
      );
    }

    final cartItem = ref.watch(cartProvider).firstWhere(
          (item) => item.product.id == product.id,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () async {
            try {
              await ref
                  .read(cartProvider.notifier)
                  .decrementQuantity(product.id);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update cart: $e')),
              );
            }
          },
        ),
        Text(cartItem.quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            try {
              await ref
                  .read(cartProvider.notifier)
                  .incrementQuantity(product.id);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update cart: $e')),
              );
            }
          },
        ),
      ],
    );
  }
}
