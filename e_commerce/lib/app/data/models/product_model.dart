import 'package:intl/intl.dart';

/// Representasi produk yang digunakan oleh katalog, detail, wishlist, dan cart.
class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final String imageUrl;
  final String description;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.description = '',
  });

  String get formattedPrice => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(price);

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final rawPrice = map['price'] ?? map['displayed_price'] ?? 0;
    final rawRating = map['rating'] ?? 0;
    final rawName = map['name'] ?? map['title'] ?? 'Produk tanpa nama';
    final rawImage = map['imageUrl'] ?? map['image'] ?? map['thumbnail'] ?? '';

    return ProductModel(
      id: (map['id'] ?? '').toString(),
      name: rawName.toString(),
      category: (map['category'] ?? 'Lainnya').toString(),
      price: _parsePrice(rawPrice),
      rating: rawRating is num
          ? rawRating.toDouble()
          : (double.tryParse(rawRating.toString()) ?? 0),
      imageUrl: rawImage.toString(),
      description: (map['description'] ?? '').toString(),
    );
  }

  static int _parsePrice(dynamic value) {
    if (value is num) return value.round();
    final digitsOnly = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digitsOnly) ?? 0;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price,
    'rating': rating,
    'imageUrl': imageUrl,
    'description': description,
  };
}
