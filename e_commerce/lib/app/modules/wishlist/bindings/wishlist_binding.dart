import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    // Wishlist reads the existing HomeController created by HomeBinding.
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }

    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
