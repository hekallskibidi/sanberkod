import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final quantity = 1.obs;
  final selectedSize = '42'.obs;
  final isFavorite = false.obs;

  late final ProductModel product;
  final List<String> availableSizes = const [
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
  ];

  CartController get cartController => Get.find<CartController>();
  HomeController get homeController => Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;

    if (arguments is ProductModel) {
      product = arguments;
    } else if (arguments is Map) {
      product = ProductModel.fromMap(Map<String, dynamic>.from(arguments));
    } else {
      product = homeController.products.first;
    }

    isFavorite.value = homeController.isFavorite(product.id);
  }

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectSize(String size) {
    if (availableSizes.contains(size)) selectedSize.value = size;
  }

  void toggleFavorite() {
    homeController.toggleFavorite(product.id);
    isFavorite.value = homeController.isFavorite(product.id);
  }

  void addToCart() {
    cartController.addItem(
      product,
      quantity: quantity.value,
      size: selectedSize.value,
    );

    Get.snackbar(
      'Berhasil Ditambahkan',
      '${quantity.value} ${product.name} (Size ${selectedSize.value}) masuk ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
