import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final quantity = 1.obs;
  final selectedSize = 42.obs;
  final isFavorite = false.obs;

  late final Map<String, dynamic> product;

  final List<int> availableSizes = const [39, 40, 41, 42, 43, 44];

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is Map) {
      product = Map<String, dynamic>.from(arguments);
    } else {
      // Fallback jika halaman detail dibuka tanpa argumen.
      product = {
        'id': 'default-sneaker',
        'title': 'Nike Air Jordan 1 Retro High',
        'category': 'Basketball',
        'price': 'Rp 2.499.000',
        'rating': 4.9,
        'image':
            'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
      };
    }

    final productId = product['id']?.toString();

    if (productId != null && Get.isRegistered<HomeController>()) {
      isFavorite.value = Get.find<HomeController>().isFavorite(productId);
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void selectSize(int size) {
    selectedSize.value = size;
  }

  void toggleFavorite() {
    final productId = product['id']?.toString();

    if (productId != null && Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.toggleFavorite(productId);
      isFavorite.value = homeController.isFavorite(productId);
    } else {
      isFavorite.toggle();
    }
  }

  void addToCart() {
    // HomeController tetap menjadi sumber state cartCount.
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    homeController.addToCart(product, quantity: quantity.value);

    Get.snackbar(
      'Berhasil Ditambahkan',
      '${quantity.value} item ${product['title']} '
          '(Size ${selectedSize.value}) masuk ke keranjang!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
