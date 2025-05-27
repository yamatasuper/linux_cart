import 'package:dio/dio.dart';
import 'package:linux_cart/models/product.dart';

class ProductApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8090',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/products/');
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load products: ${e.message}');
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load product: ${e.message}');
    }
  }
}
