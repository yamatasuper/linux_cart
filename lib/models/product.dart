class Product {
  final int id;
  final String name;
  final String? sku;
  final String? description;
  final String? category;
  final double price;
  final int quantity;
  final String currency;
  final bool? isAvailable;
  final List<String>? imageUrls;

  Product({
    required this.id,
    required this.name,
    this.sku,
    this.description,
    this.category,
    required this.price,
    required this.quantity,
    required this.currency,
    this.isAvailable,
    this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int? ?? 0,
      currency: json['currency'] as String,
      isAvailable: json['isAvailable'] as bool?,
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'category': category,
      'price': price,
      'quantity': quantity,
      'currency': currency,
      'isAvailable': isAvailable,
      'imageUrl': imageUrls,
    };
  }
}
