import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class WishlistController extends GetxController {
  HomeController get homeController => Get.find<HomeController>();
  CartController get cartController => Get.find<CartController>();

  List<ProductModel> get wishlistItems => homeController.products
      .where((product) => homeController.favoriteIds.contains(product.id))
      .toList(growable: false);

  void removeFromWishlist(ProductModel product) {
    homeController.favoriteIds.remove(product.id);
  }

  void moveToCart(ProductModel product, {String size = '42'}) {
    cartController.addItem(product, size: size);
    homeController.favoriteIds.remove(product.id);
    Get.snackbar(
      'Dipindahkan ke Keranjang',
      '${product.name} berhasil dipindahkan dari wishlist.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
