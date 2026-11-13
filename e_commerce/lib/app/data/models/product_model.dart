import 'package:intl/intl.dart';

/// Typed product entity shared by home, detail, wishlist, and cart.
class ProductModel {
  static const int usdToIdrRate = 15000;

  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.reviewCount = 0,
    this.description = '',
    this.isFavorite = false,
  });

  String get formattedPrice => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(price);

  /// Parses a DummyJSON product defensively and converts USD to IDR.
  /// DummyJSON currently returns numeric USD prices such as 149.99.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId == null || rawId.toString().trim().isEmpty
        ? 'product-${DateTime.now().microsecondsSinceEpoch}'
        : rawId.toString();

    final rawName = json['title'] ?? json['name'] ?? 'Sepatu Sneakers';
    final rawCategory = (json['category'] ?? 'Lifestyle').toString();
    final priceInRupiah = _parsePriceToRupiah(
      json['price'] ?? json['displayed_price'],
    );

    final rawRating = json['rating'];
    final rating = rawRating is num
        ? rawRating.toDouble()
        : double.tryParse(rawRating?.toString() ?? '') ?? 4.8;

    final rawReviews = json['reviews'];
    final rawReviewCount = json['reviewCount'];
    final reviewCount = rawReviewCount is num
        ? rawReviewCount.toInt()
        : (rawReviews is List ? rawReviews.length : 0);

    final rawImages = json['images'];
    final firstImage = rawImages is List && rawImages.isNotEmpty
        ? rawImages.first
        : null;
    final candidate =
        (json['thumbnail'] ??
                json['imageUrl'] ??
                json['image'] ??
                firstImage ??
                '')
            .toString()
            .trim();
    final imageUrl = candidate.isEmpty
        ? 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'
        : candidate;

    final rawFavorite = json['isFavorite'];

    return ProductModel(
      id: id,
      name: rawName.toString(),
      category: _formatCategory(rawCategory),
      price: priceInRupiah,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      description:
          (json['description'] ??
                  'Sepatu sneakers berkualitas untuk aktivitas sehari-hari.')
              .toString(),
      isFavorite: rawFavorite is bool ? rawFavorite : false,
    );
  }

  /// Keeps Sesi 03 cart/detail serialization compatible with this model.
  /// Values already serialized as IDR are not converted a second time.
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel.fromJson(map);
  }

  static int _parsePriceToRupiah(dynamic rawValue) {
    if (rawValue == null) return 150000;

    if (rawValue is num) {
      if (!rawValue.isFinite || rawValue < 0) return 0;
      return rawValue < 1000
          ? (rawValue * usdToIdrRate).round()
          : rawValue.round();
    }

    final text = rawValue.toString().trim();
    if (text.isEmpty) return 150000;

    final normalized = text.replaceAll(RegExp(r'[^0-9.,-]'), '');
    if (normalized.isEmpty) return 0;

    // Indonesian Rupiah strings such as "Rp 2.499.000" are already IDR.
    final lowerText = text.toLowerCase();
    if (lowerText.contains('rp') || lowerText.contains('idr')) {
      final digits = normalized.replaceAll(RegExp(r'[^0-9-]'), '');
      return int.tryParse(digits) ?? 0;
    }

    // USD strings such as "$149.99" retain their decimal separator.
    final usdText = normalized.replaceAll(',', '');
    final parsed =
        num.tryParse(usdText) ?? num.tryParse(normalized.replaceAll(',', '.'));
    if (parsed == null || !parsed.isFinite || parsed < 0) return 0;

    return parsed < 1000 ? (parsed * usdToIdrRate).round() : parsed.round();
  }

  static String _formatCategory(String value) {
    final normalized = value.trim().replaceAll('-', ' ');
    if (normalized.isEmpty) return 'General';

    return normalized
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'title': name,
    'category': category,
    'price': price,
    'rating': rating,
    'reviewCount': reviewCount,
    'imageUrl': imageUrl,
    'description': description,
    'isFavorite': isFavorite,
  };
}
