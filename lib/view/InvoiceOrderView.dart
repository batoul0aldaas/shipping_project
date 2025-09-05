import 'package:ba11/view/payment_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/paymentInfo_controller.dart';
import '../controller/invoice_order_controller.dart';
import '../services/api_payment_service.dart';
import '../services/api_InvoiceOrder.dart';

class InvoiceOrderView extends StatelessWidget {
  final int orderId;
  final bool showPayButton;
  final bool isDeliveredOrder;
  final InvoiceOrderController controller = Get.put(InvoiceOrderController());
  final PaymentInfoController paymentController = Get.put(PaymentInfoController());

  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  InvoiceOrderView({
    required this.orderId,
    this.showPayButton = false,
    this.isDeliveredOrder = false,
    Key? key,
  }) : super(key: key) {
    controller.loadOrderInvoice(orderId);
    paymentController.loadPaymentInfo(orderId);
  }

  static const List<String> allowedCurrencies = [
    "USD", "JOD", "KWT", "SAU", "ARE", "QAT", "OMN", "EGY", "BHR"
  ];

  Future<void> _chooseCurrencyAndPay(int invoiceId, {bool isRemaining25 = false}) async {
    final selectedCurrency = await Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "اختر العملة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.3,
              physics: const NeverScrollableScrollPhysics(),
              children: allowedCurrencies.map((currency) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Get.back(result: currency),
                  child: Text(
                    currency,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (selectedCurrency != null) {
      await _startPayment(invoiceId, selectedCurrency, isRemaining25: isRemaining25);
    }
  }

  Future<void> _startPayment(int invoiceId, String currency, {bool isRemaining25 = false}) async {
    try {
      final payRes = await ApiPaymentService.payInvoice(invoiceId, currency);
      final data = payRes["data"] ?? {};
      final paymentLink = data["payment_link"] ?? "";
      final mfInvoiceId = data["mf_invoice_id"]?.toString() ?? "";

      if (paymentLink.isNotEmpty && mfInvoiceId.isNotEmpty) {
        final result = await Navigator.of(Get.context!).push(
          MaterialPageRoute(builder: (_) => PaymentWebView(paymentLink: paymentLink)),
        );

        if (result == true) {
          await _verifyPayment(invoiceId, mfInvoiceId, isRemaining25: isRemaining25);
        }
      } else {
        _showError("رابط الدفع أو معرف الفاتورة غير متاح");
      }
    } catch (e) {
      _showError("حدث خطأ أثناء بدء الدفع: $e");
    }
  }

  Future<void> _verifyPayment(int invoiceId, String mfInvoiceId, {bool isRemaining25 = false}) async {
    try {
      final verifyRes = await ApiPaymentService.verifyPayment(invoiceId, mfInvoiceId);

      if (verifyRes["status"] == 1 && verifyRes["data"]["status"] == "succeeded") {
        _showSuccess("تم الدفع بنجاح ✅\n${verifyRes["message"]}");
        controller.loadOrderInvoice(invoiceId);
        if (isRemaining25) {
          paymentController.paymentInfo.update((val) {
            if (val != null) {
              val.paidAmount += val.nextPaymentAmount;
              val.dueAmount = 0;
              val.nextPaymentAmount = 0;
              val.nextPaymentPhase = "paid";
            }
          });
        } else {
          paymentController.loadPaymentInfo(invoiceId);
        }

        Get.back();
      } else {
        _showError("فشل التحقق من الدفع\n${verifyRes["message"]}");
      }
    } catch (e) {
      _showError("خطأ أثناء التحقق من الدفع: $e");
    }
  }

  void _showError(String message) {
    Get.snackbar("خطأ", message, backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _showSuccess(String message) {
    Get.snackbar("نجاح", message, backgroundColor: Colors.green, colorText: Colors.white);
  }

  Widget infoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple.shade400, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: valueColor ?? Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPayRemainingButton(BuildContext context, double remainingAmount, int invoiceId) {
    return GestureDetector(
      onTap: () => _chooseCurrencyAndPay(invoiceId, isRemaining25: true),
      child: Container(
        height: 58,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade400]),
        ),
        child: Center(
          child: Text(
            'ادفع 25% المتبقي: \$${remainingAmount.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade50], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value || paymentController.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
            }

            final invoice = controller.invoice.value;
            final paymentInfo = paymentController.paymentInfo.value;

            if (invoice == null) {
              return const Center(child: Text('لا توجد فاتورة لعرضها', style: TextStyle(fontSize: 18, color: Colors.black54)));
            }

            final paidStatus = invoice.paymentStatus;
            final paidAmount = paymentInfo?.paidAmount ?? 0;
            final remainingAmount = paymentInfo?.dueAmount ?? invoice.totalFinalAmount;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: Colors.deepPurple.shade400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26)),
                      const Text("تفاصيل الفاتورة", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () { ApiInvoiceService.downloadOrderInvoice(orderId); }, icon: const Icon(Icons.download, color: Colors.white, size: 26)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Container(
                          padding: const EdgeInsets.all(50),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 6))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("رقم الفاتورة", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                              const SizedBox(height: 6),
                              Text(invoice.invoiceNumber.toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                              const SizedBox(height: 10),
                              Text("الحالة: $paidStatus", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: invoice.nextPaymentAmount == 0 ? Colors.green : Colors.red)),
                              const Divider(height: 30, thickness: 1.2),
                              infoRow(Icons.attach_money, 'المبلغ الأولي', currencyFormat.format(invoice.totalInitialAmount)),
                              infoRow(Icons.account_balance, 'رسوم الجمارك', currencyFormat.format(invoice.totalCustomsFee)),
                              infoRow(Icons.miscellaneous_services, 'رسوم الخدمة', currencyFormat.format(invoice.totalServiceFee)),
                              infoRow(Icons.trending_up, 'ربح الشركة', currencyFormat.format(invoice.totalCompanyProfit)),
                              infoRow(Icons.done_all, 'المبلغ النهائي', currencyFormat.format(invoice.totalFinalAmount), valueColor: Colors.green),
                              const SizedBox(height: 10),
                              Text('المبلغ المدفوع: \$${paidAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('المبلغ المتبقي: \$${remainingAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        if (isDeliveredOrder || (invoice.nextPaymentAmount > 0 && paidStatus != "مدفوع"))
                          _buildPayRemainingButton(context, invoice.nextPaymentAmount, invoice.id),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
