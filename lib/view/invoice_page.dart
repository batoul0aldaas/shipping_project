import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/invoice_controller.dart';
import '../model/invoice_model.dart';
import '../services/api_invoice_service.dart';

class InvoiceView extends StatelessWidget {
  final int shipmentId;
  final InvoiceController controller = Get.put(InvoiceController());
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  InvoiceView({required this.shipmentId, Key? key}) : super(key: key) {
    controller.loadInvoice(shipmentId);
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
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
            }
            if (controller.invoice.value == null) {
              return const Center(
                child: Text('لا توجد فاتورة لعرضها',
                    style: TextStyle(fontSize: 18, color: Colors.black54)),
              );
            }
            final InvoiceModel invoice = controller.invoice.value!;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.shade200.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'فاتورة الشحنة',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.print, color: Colors.white),
                        onPressed: () {
                          Get.snackbar("تنبيه", "ميزة الطباعة سيتم تنفيذها لاحقًا",
                              backgroundColor: Colors.white.withOpacity(0.8));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        tooltip: "تحميل الفاتورة",
                        onPressed: () {
                          if (controller.invoice.value != null) {
                            ApiInvoiceService.downloadInvoiceFile(controller.invoice.value!.id);
                          } else {
                            Get.snackbar("خطأ", "لا توجد فاتورة لتحميلها",
                                backgroundColor: Colors.white.withOpacity(0.8));
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade100.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'رقم الفاتورة',
                              style: TextStyle(
                                  color: Colors.deepPurple.shade600,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${invoice.invoiceNumber}',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade900),
                              textAlign: TextAlign.center,
                            ),
                            const Divider(height: 36, thickness: 2),
                            infoRow(Icons.receipt, 'نوع الفاتورة', invoice.invoiceType),
                            infoRow(Icons.monetization_on, 'المبلغ الأولي',
                                currencyFormat.format(invoice.initialAmount)),
                            infoRow(Icons.account_balance_wallet, 'رسوم الجمارك',
                                currencyFormat.format(invoice.customsFee)),
                            infoRow(Icons.build_circle, 'رسوم الخدمة',
                                currencyFormat.format(invoice.serviceFee)),
                            infoRow(Icons.trending_up, 'ربح الشركة',
                                currencyFormat.format(invoice.companyProfit)),
                            infoRow(
                              Icons.attach_money,
                              'المبلغ النهائي',
                              currencyFormat.format(invoice.finalAmount),
                              valueColor: Colors.green.shade700,
                            ),

                            const SizedBox(height: 24),
                            Text(
                              'ملاحظات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              invoice.notes.isNotEmpty ? invoice.notes : 'لا توجد ملاحظات',
                              style: const TextStyle(fontSize: 16, height: 1.3),
                            ),
                          ],
                        ),
                      ),
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
