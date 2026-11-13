import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  HomeController(this._productRepository);

  final ProductRepository _productRepository;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final selectedCategory = 'Semua'.obs;
  final favoriteIds = <String>{}.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasRemoteData = false.obs;

  static const List<ProductModel> _fallbackProducts = [
    ProductModel(
      id: 'nike-air-jordan-1-retro-high',
      name: 'Nike Air Jordan 1 Retro High',
      category: 'Basketball',
      price: 2499000,
      rating: 4.9,
      reviewCount: 120,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=700&q=85',
      description: 'Sneakers ikonik untuk gaya harian dan aktivitas kasual.',
    ),
    ProductModel(
      id: 'nike-air-force-1-07-triple-white',
      name: 'Nike Air Force 1 07 Triple White',
      category: 'Lifestyle',
      price: 1549000,
      rating: 4.8,
      reviewCount: 96,
      imageUrl:
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=700&q=85',
      description: 'Desain klasik dengan siluet clean dan mudah dipadukan.',
    ),
    ProductModel(
      id: 'adidas-ultraboost-light-running',
      name: 'Adidas Ultraboost Light Running',
      category: 'Running',
      price: 2899000,
      rating: 4.7,
      reviewCount: 88,
      imageUrl:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=700&q=85',
      description: 'Sepatu lari dengan bantalan nyaman untuk latihan harian.',
    ),
    ProductModel(
      id: 'puma-suede-classic-xxi-black',
      name: 'Puma Suede Classic XXI Black',
      category: 'Casual',
      price: 1099000,
      rating: 4.6,
      reviewCount: 74,
      imageUrl:
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=700&q=85',
      description:
          'Sneakers suede bergaya klasik untuk penggunaan sehari-hari.',
    ),
    ProductModel(
      id: 'new-balance-574-core-grey',
      name: 'New Balance 574 Core Grey',
      category: 'Lifestyle',
      price: 1499000,
      rating: 4.8,
      reviewCount: 103,
      imageUrl:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=700&q=85',
      description: 'Kenyamanan sepanjang hari dengan desain timeless.',
    ),
    ProductModel(
      id: 'vans-old-skool-classic-skate',
      name: 'Vans Old Skool Classic Skate',
      category: 'Skate',
      price: 999000,
      rating: 4.7,
      reviewCount: 91,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=700&q=85',
      description: 'Model skate klasik dengan side stripe khas Vans.',
    ),
  ];

  CartController get cartController => Get.find<CartController>();
  int get cartCount => cartController.totalItemCount;

  List<String> get categories => [
    'Semua',
    ...products.map((product) => product.category).toSet(),
  ];

  List<ProductModel> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products.toList(growable: false);
    return products
        .where((product) => product.category == category)
        .toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    // Ignore repeated requests while a request is already in progress.
    if (isLoading.value) return;

    final hadDisplayedProducts = products.isNotEmpty;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _productRepository.fetchProducts();

      switch (result) {
        case Success(data: final remoteProducts):
          products.assignAll(remoteProducts);
          hasRemoteData.value = true;
          if (!categories.contains(selectedCategory.value)) {
            selectedCategory.value = 'Semua';
          }

          Get.snackbar(
            'Katalog Berhasil Diperbarui',
            'Berhasil mengunduh ${remoteProducts.length} sepatu terbaru dari server!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            icon: const Icon(Icons.cloud_done_rounded, color: Colors.white),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );

        case Failure(error: final error):
          errorMessage.value = error;
          if (products.isEmpty) {
            products.assignAll(_fallbackProducts);
          }

          if (hadDisplayedProducts) {
            Get.snackbar(
              'Mode Offline',
              'Koneksi ke server terputus. Produk yang sudah tampil tetap tersedia.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.error,
              colorText: Colors.white,
              icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          }
      }
    } catch (error) {
      errorMessage.value = 'Gagal memuat katalog. Silakan coba lagi.';
      if (products.isEmpty) {
        products.assignAll(_fallbackProducts);
      }

      if (hadDisplayedProducts) {
        Get.snackbar(
          'Mode Offline',
          'Koneksi ke server terputus. Produk yang sudah tampil tetap tersedia.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(String category) {
    if (categories.contains(category)) selectedCategory.value = category;
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }

  void addToCart(ProductModel product, {int quantity = 1, String size = '42'}) {
    cartController.addItem(product, quantity: quantity, size: size);
  }

  void openDetail(ProductModel product) {
    Get.toNamed('/detail', arguments: product);
  }
}
