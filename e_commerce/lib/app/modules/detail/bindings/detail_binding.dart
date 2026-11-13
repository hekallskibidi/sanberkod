import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    // HomeController is already created by HomeBinding before Detail is opened.
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }

    Get.lazyPut<DetailController>(() => DetailController());
  }
}
