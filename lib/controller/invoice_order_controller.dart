import 'package:get/get.dart';
import '../model/invoice_order_model.dart';
import '../services/api_InvoiceOrder.dart';

class InvoiceOrderController extends GetxController {
  var isLoading = false.obs;
  var invoice = Rxn<InvoiceOrderModel>();
  var statusMessage = ''.obs;

  Future<void> loadOrderInvoice(int orderId) async {
    try {
      isLoading.value = true;
      final result = await ApiInvoiceService.fetchOrderInvoice(orderId);

      if (result != null) {
        invoice.value = result;
        statusMessage.value = "تم تحميل فاتورة الأوردر بنجاح";
      } else {
        statusMessage.value = "فشل تحميل فاتورة الأوردر";
      }
    } finally {
      isLoading.value = false;
    }
  }
}
