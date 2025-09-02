import 'package:get/get.dart';
import '../model/PaymentInfoModel.dart';
import '../services/api_payment_service.dart';

class PaymentInfoController extends GetxController {
  var isLoading = false.obs;
  var paymentInfo = Rxn<PaymentInfo>();
  var errorMessage = ''.obs;

  Future<void> loadPaymentInfo(int orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print("LOADING PAYMENT INFO FOR ORDER ID: $orderId");

      final response = await ApiPaymentService.getPaymentInfo(orderId);

      print("RESPONSE RECEIVED IN CONTROLLER: $response");

      if (response is Map<String, dynamic>) {
        print("RESPONSE STATUS: ${response['status']}");
        print("RESPONSE MESSAGE: ${response['message']}");

        if ((response['status'] ?? 0) == 1) {
          paymentInfo.value = PaymentInfoResponse.fromJson(response).data;
          print("PAYMENT INFO LOADED SUCCESSFULLY:");
          print(paymentInfo.value);
        } else {
          errorMessage.value = response['message']?.toString() ?? 'حدث خطأ أثناء جلب بيانات الدفع';
          print("ERROR MESSAGE: ${errorMessage.value}");
        }
      } else {
        errorMessage.value = 'نوع الاستجابة غير متوقع';
        print("ERROR: Unexpected response type");
      }
    } catch (e) {
      errorMessage.value = 'فشل الاتصال بالخادم: $e';
      print("EXCEPTION OCCURRED: $e");
    } finally {
      isLoading.value = false;
      print("LOADING COMPLETE");
    }
  }
}
