import 'package:ba11/services/api_rate_service.dart';
import 'package:ba11/view/shipment_for_order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../model/OrderModel.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/rating_dialog.dart';
import 'ChatView.dart';
import 'InvoiceOrderView.dart';
import 'shipment_tracking_view.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController());
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'إدارة الطلبات',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
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
                        onSelected: (_) =>
                            controller.fetchOrderListOnly("unconfirmed"),
                        selectedColor: const Color(0xFFFF6B6B),
                        icon: Icons.pending_actions_rounded,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildChoiceChip(
                        label: "طلبات مؤكدة",
                        selected: controller.selectedTab.value == "confirmed",
                        onSelected: (_) =>
                            controller.fetchOrderListOnly("confirmed"),
                        selectedColor: const Color(0xFF4ECDC4),
                        icon: Icons.check_circle_rounded,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildChoiceChip(
                        label: "طلبات مستلمة",
                        selected: controller.selectedTab.value == "delivered",
                        onSelected: (_) =>
                            controller.fetchOrderListOnly("delivered"),
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
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF667EEA),
                            ),
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'جاري تحميل الطلبات...',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final orders = controller.selectedTab.value == "confirmed"
                ? controller.confirmedOrders
                : controller.selectedTab.value == "unconfirmed"
                ? controller.unconfirmedOrders
                : controller.deliveredOrders;

            if (orders.isEmpty) {
              String message;
              IconData icon;

              if (controller.selectedTab.value == "confirmed") {
                message = "لا توجد طلبات مؤكدة";
                icon = Icons.check_circle_outline_rounded;
              } else if (controller.selectedTab.value == "unconfirmed") {
                message = "لا توجد طلبات غير مؤكدة";
                icon = Icons.pending_actions_outlined;
              } else {
                message = "لا توجد طلبات مستلمة";
                icon = Icons.local_shipping_outlined;
              }

              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          icon,
                          size: 40,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ستظهر الطلبات هنا عند توفرها',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
          border: Border.all(
            color: selected ? selectedColor : Colors.white.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? selectedColor : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? selectedColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
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
  final controller = Get.find<OrderController>();
  OrderTile(this.order, {required this.confirmed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF8FAFC)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(
                () => ShipmentForOrderView(
                  orderId: order.id,
                  isOrderConfirmed: confirmed,
                ),
              );
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
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "رقم الطلب: ${order.orderNumber}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "حالة الطلب: ${order.orderStatus} "
                          "...",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!confirmed &&
                          controller.selectedTab.value != "delivered") ...[
                        GestureDetector(
                          onTap: () {
                            controller.confirmOrderById(order.id);
                          },
                          child: _iconButton(
                            gradientColors: const [
                              Color(0xFF4ECDC4),
                              Color(0xFF44A08D),
                            ],
                            icon: Icons.check_circle_outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ChatView(orderId: order.id));
                          },
                          child: _iconButton(
                            gradientColors: const [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                            ],
                            icon: Icons.chat,
                          ),
                        ),
                      ],

                      if (confirmed &&
                          controller.selectedTab.value != "delivered") ...[
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ChatView(orderId: order.id));
                          },
                          child: _iconButton(
                            gradientColors: const [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                            ],
                            icon: Icons.chat,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => InvoiceOrderView(orderId: order.id));
                          },
                          child: _iconButton(
                            gradientColors: const [
                              Color(0xFFFFA726),
                              Color(0xFFF57C00),
                            ],
                            icon: Icons.receipt_long,
                          ),
                        ),
                      ],

                      if (controller.selectedTab.value == "delivered") ...[
                        GestureDetector(
                          onTap: () {
                            Get.to(() => InvoiceOrderView(orderId: order.id));
                          },
                          child: _iconButton(
                            gradientColors: const [
                              Color(0xFFFFA726),
                              Color(0xFFF57C00),
                            ],
                            icon: Icons.receipt_long,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            RatingDialog.show(context, order.id, (
                              id,
                              employeeRate,
                              serviceRate,
                            ) async {
                              return await ApiRateService.rateOrder(
                                id,
                                employeeRate,
                                serviceRate,
                              );
                            });
                          },
                          child: _iconButton(
                            gradientColors: const [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                            ],
                            icon: Icons.star_rate,
                          ),
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

  Widget _iconButton({
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
