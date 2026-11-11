import 'product_model.dart';

/// Satu baris item pada keranjang: produk + ukuran + kuantitas.
class CartItemModel {
  final ProductModel product;
  final String selectedSize;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.selectedSize,
    required this.quantity,
  });

  /// ID komposit membuat produk dengan ukuran berbeda menjadi baris terpisah.
  String get id => '${product.id}_$selectedSize';

  int get subtotal => product.price * quantity;

  String get formattedSubtotal => product.formattedPriceFor(subtotal);

  CartItemModel copyWith({int? quantity, String? selectedSize}) {
    return CartItemModel(
      product: product,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final rawProduct = map['product'];
    if (rawProduct is! Map) {
      throw const FormatException(
        'CartItemModel membutuhkan field product berupa Map.',
      );
    }

    final rawQuantity = map['quantity'];
    final parsedQuantity = rawQuantity is num
        ? rawQuantity.toInt()
        : int.tryParse(rawQuantity?.toString() ?? '') ?? 1;

    return CartItemModel(
      product: ProductModel.fromMap(Map<String, dynamic>.from(rawProduct)),
      selectedSize: (map['selectedSize'] ?? map['size'] ?? '42').toString(),
      quantity: parsedQuantity < 1 ? 1 : parsedQuantity,
    );
  }

  Map<String, dynamic> toMap() => {
    'product': product.toMap(),
    'selectedSize': selectedSize,
    'quantity': quantity,
  };
}

extension _ProductPriceFormatter on ProductModel {
  String formattedPriceFor(int amount) {
    final digits = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $digits';
  }
}
