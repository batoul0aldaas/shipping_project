
import 'package:get/get.dart';
import '../model/OrderModel.dart';
import '../services/api_shipment_service.dart';

class OrderController extends GetxController {
  final ApiShipmentService api = ApiShipmentService();

  var confirmedOrders = <OrderModel>[].obs;
  var unconfirmedOrders = <OrderModel>[].obs;
  var deliveredOrders = <OrderModel>[].obs;
  var isLoading = false.obs;

  var selectedTab = "unconfirmed".obs;

  void fetchOrderListOnly(String type) async {
    isLoading.value = true;
    selectedTab.value = type;
    try {
      var result = await api.getOrdersByType(type: type);
      if (type == "confirmed") {
        confirmedOrders.value = result;
      } else if (type == "unconfirmed") {
        unconfirmedOrders.value = result;
      } else if (type == "delivered") {
        deliveredOrders.value = result;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmOrderById(int orderId) async {
    final message = await ApiShipmentService.confirmOrder(orderId);
    if (message == "Order confirmed successfully.") {
      Get.snackbar("تم", message);
      fetchOrderListOnly("unconfirmed");
    } else {
      Get.snackbar("تنبيه", message);
    }
  }



}
