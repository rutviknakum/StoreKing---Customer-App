import 'package:get/get.dart';
import 'package:ebazaar/app/modules/cart/controller/cart_controller.dart';

class CartControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController());
  }
}
