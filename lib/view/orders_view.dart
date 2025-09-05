import 'package:ba11/view/payment_webview.dart';
import 'package:ba11/view/shipment_for_order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../controller/invoice_order_controller.dart';
import '../model/OrderModel.dart';
import '../widgets/custom_drawer.dart';
import 'ChatView.dart';
import 'InvoiceOrderView.dart';
import '../services/api_payment_service.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController());
    final InvoiceOrderController invoiceController = Get.put(InvoiceOrderController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('إدارة الطلبات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildChoiceChip(
                        label: "طلبات غيرمؤكدة",
                        selected: controller.selectedTab.value == "unconfirmed",
                        onSelected: (_) => controller.fetchOrderListOnly("unconfirmed"),
                        selectedColor: const Color(0xFFFF6B6B),
                        icon: Icons.pending_actions_rounded,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildChoiceChip(
                        label: "طلبات مؤكدة",
                        selected: controller.selectedTab.value == "confirmed",
                        onSelected: (_) => controller.fetchOrderListOnly("confirmed"),
                        selectedColor: const Color(0xFF4ECDC4),
                        icon: Icons.check_circle_rounded,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildChoiceChip(
                        label: "طلبات مستلمة",
                        selected: controller.selectedTab.value == "delivered",
                        onSelected: (_) => controller.fetchOrderListOnly("delivered"),
                        selectedColor: const Color(0xFFFFA726),
                        icon: Icons.local_shipping_rounded,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            }

            final orders = controller.selectedTab.value == "confirmed"
                ? controller.confirmedOrders
                : controller.selectedTab.value == "unconfirmed"
                ? controller.unconfirmedOrders
                : controller.deliveredOrders;

            if (orders.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text("لا توجد طلبات متاحة", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderTile(
                    orders[index],
                    confirmed: controller.selectedTab.value == "confirmed",
                    delivered: controller.selectedTab.value == "delivered",
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required Color selectedColor,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? selectedColor : Colors.white.withOpacity(0.2), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? selectedColor : Colors.white, size: 20),
            const SizedBox(width: 12),
            Flexible(
              child: Text(label, style: TextStyle(color: selected ? selectedColor : Colors.white, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final OrderModel order;
  final bool confirmed;
  final bool delivered;
  final controller = Get.find<OrderController>();
  final invoiceController = Get.find<InvoiceOrderController>();

  OrderTile(this.order, {required this.confirmed, required this.delivered, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFF8FAFC)]),
          boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.08), blurRadius: 25, offset: const Offset(0, 12))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(() => ShipmentForOrderView(orderId: order.id, isOrderConfirmed: confirmed));
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("رقم الطلب: ${order.orderNumber}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1E293B))),
                        const SizedBox(height: 5),
                        Text("حالة الطلب: ${order.orderStatus} ...", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!confirmed && !delivered) ...[
                        GestureDetector(
                          onTap: () => _chooseCurrencyAndConfirmAndPay(context, order.id),
                          child: _iconButton(gradientColors: const [Color(0xFF4ECDC4), Color(0xFF44A08D)], icon: Icons.check_circle_outline),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Get.to(() => ChatView(orderId: order.id)),
                          child: _iconButton(gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)], icon: Icons.chat),
                        ),
                      ],
                      if (confirmed && !delivered) ...[
                        GestureDetector(
                          onTap: () => Get.to(() => InvoiceOrderView(orderId: order.id, showPayButton: false)),
                          child: _iconButton(gradientColors: const [Color(0xFFFFA726), Color(0xFFF57C00)], icon: Icons.receipt_long),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Get.to(() => ChatView(orderId: order.id)),
                          child: _iconButton(gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)], icon: Icons.chat),
                        ),
                      ],
                      if (delivered) ...[
                        GestureDetector(
                          onTap: () => Get.to(() => InvoiceOrderView(orderId: order.id, showPayButton: true, isDeliveredOrder: true)),
                          child: _iconButton(gradientColors: const [Color(0xFFFFA726), Color(0xFFF57C00)], icon: Icons.receipt_long),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Get.to(() => ChatView(orderId: order.id)),
                          child: _iconButton(gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)], icon: Icons.chat),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton({required List<Color> gradientColors, required IconData icon}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  static const List<String> allowedCurrencies = [
    "USD", "JOD", "KWT", "SAU", "ARE", "QAT", "OMN", "EGY", "BHR"
  ];

  void _chooseCurrencyAndConfirmAndPay(BuildContext context, int orderId) async {
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
            const Text("اختر العملة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  child: Text(currency, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (selectedCurrency == null) return;

    try {
      final data = await ApiPaymentService.confirmOrder(orderId, selectedCurrency);
      final paymentLink = data['data']['payment_link'];
      final mfInvoiceId = data['data']['mf_invoice_id'];

      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentWebView(paymentLink: paymentLink)),
      );

      if (result == true) {
        final verify = await ApiPaymentService.verifyPayment(orderId, mfInvoiceId);

        if (verify['status'] == 1 && verify['data']['status'] == 'succeeded') {
          Get.snackbar("نجاح", "تم الدفع بنجاح!");
          controller.fetchOrderListOnly("confirmed");
        } else {
          Get.snackbar("فشل", "فشل التحقق من الدفع");
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    }
  }
}
