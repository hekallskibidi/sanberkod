import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // CartController harus satu instance dan hidup lintas halaman.
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
