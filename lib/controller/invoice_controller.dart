import 'package:get/get.dart';
import '../model/invoice_model.dart';
import '../services/api_invoice_service.dart';

class InvoiceController extends GetxController {
  var isLoading = false.obs;
  var invoice = Rxn<InvoiceModel>();
  var statusMessage = ''.obs;

  Future<void> loadInvoice(int shipmentId) async {
    try {
      isLoading.value = true;
      final result = await ApiInvoiceService.fetchInvoice(shipmentId);

      if (result != null) {
        invoice.value = result;
        statusMessage.value = "تم تحميل الفاتورة بنجاح";
      } else {
        statusMessage.value = "فشل تحميل الفاتورة";
      }
    } finally {
      isLoading.value = false;
    }
  }
}
