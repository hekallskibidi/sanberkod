import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  static const int taxRatePercent = 11;
  static const int freeShippingThreshold = 2000000;
  static const int standardShippingFee = 20000;

  int get totalItemCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
  int get uniqueItemCount => items.length;
  int get subtotal => items.fold<int>(0, (sum, item) => sum + item.subtotal);
  int get tax => (subtotal * taxRatePercent / 100).round();
  int get shippingFee {
    if (items.isEmpty) return 0;
    return subtotal >= freeShippingThreshold ? 0 : standardShippingFee;
  }

  int get totalAmount => subtotal + tax + shippingFee;

  String formatRupiah(int amount) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(amount);

  String get formattedSubtotal => formatRupiah(subtotal);
  String get formattedTax => formatRupiah(tax);
  String get formattedShippingFee => shippingFee == 0 && items.isNotEmpty
      ? 'Gratis'
      : formatRupiah(shippingFee);
  String get formattedTotalAmount => formatRupiah(totalAmount);

  void addItem(ProductModel product, {int quantity = 1, String size = '42'}) {
    if (quantity <= 0) return;

    final index = items.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size,
    );

    if (index >= 0) {
      final current = items[index];
      items[index] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      items.add(
        CartItemModel(product: product, selectedSize: size, quantity: quantity),
      );
    }
  }

  void increaseQuantity(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final current = items[index];
    items[index] = current.copyWith(quantity: current.quantity + 1);
  }

  void decreaseQuantity(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final current = items[index];
    if (current.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = current.copyWith(quantity: current.quantity - 1);
    }
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
  }

  void clearCart() {
    items.clear();
  }
}
