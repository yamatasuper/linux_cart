import 'package:flutter/material.dart';
import 'package:linux_cart/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

// Update CartScreen build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartProvider.notifier).totalPrice;
    final isLoading = ref.watch(cartProvider.notifier).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: cartAsync.isEmpty
                      ? const Center(child: Text('Корзина пуста'))
                      : ListView.builder(
                          itemCount: cartAsync.length,
                          itemBuilder: (context, index) {
                            final item = cartAsync[index];
                            return ListTile(
                              leading: const Icon(Icons.image, size: 50),
                              title: Text(item.product.name),
                              subtitle: Text(
                                  'Количество: ${item.quantity}\nВсего: \$${item.totalPrice.toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(cartProvider.notifier)
                                        .removeFromCart(item.product.id);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to remove: $e')),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Общая сумма: \$${totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
    );
  }
}
