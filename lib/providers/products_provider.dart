import 'package:linux_cart/models/product.dart';
import 'package:riverpod/riverpod.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return [
    Product(
      id: '1',
      name: 'Молоко',
      price: 2.99,
      imageUrl: 'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
    ),
    Product(
      id: '2',
      name: 'Хлеб',
      price: 1.99,
      imageUrl: 'https://pngimg.com/uploads/naruto/naruto_PNG30.png',
    ),
  ];
});
