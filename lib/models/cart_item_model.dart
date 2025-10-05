import 'dart:convert';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl; // Optional image URL

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  });

  // copyWith method for easy updates
  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Serialization
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem && other.productId == productId;
  }

  @override
  int get hashCode {
    return productId.hashCode;
  }
}
