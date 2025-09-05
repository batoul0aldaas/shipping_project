import 'package:ba11/view/shipment_tracking_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shipment-controller.dart';
import '../widgets/shipment_card.dart';
import 'contract_view.dart';
import 'edit_shipment_view.dart';
import 'invoice_page.dart';

class ShipmentForOrderView extends StatelessWidget {
  final int orderId;
  final bool isOrderConfirmed;
  ShipmentForOrderView({required this.orderId,required this.isOrderConfirmed,});

  @override
  Widget build(BuildContext context) {
    final ShipmentController controller = Get.put(ShipmentController(orderId: orderId));

    controller.fetchShipments(orderId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          ' شحنات الاوردر',
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
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        if (controller.shipments.isEmpty) return const Center(child: Text("لا توجد شحنات"));

        return ListView.builder(
          itemCount: controller.shipments.length,
          itemBuilder: (_, index) {
            final shipment = controller.shipments[index];
            return ShipmentCard(
              shipment: shipment,
              onConfirm: () {
                if (shipment.id != null) {
                  controller.confirmShipment(shipment.id!);
                } else {
                  Get.snackbar("خطأ", "رقم الشحنة غير متوفر");
                }
              },
              onEdit: () {
                if (shipment.id != null) {
                  Get.to(() => EditShipmentView(shipmentId: shipment.id!));
                } else {
                  Get.snackbar("خطأ", "رقم الشحنة غير متوفر");
                }
              },
              onDelete: () {
                if (shipment.id != null) {
                  controller.deleteShipment(shipment.id!);
                } else {
                  Get.snackbar("خطأ", "رقم الشحنة غير متوفر");
                }

              },
              onInvoice: () {
                if (shipment.id != null) {
                  Get.to(() => InvoiceView(shipmentId: shipment.id!));
                } else {
                  Get.snackbar("خطأ", "رقم الشحنة غير متوفر");
                }
              },
              onContract: () {
                if (shipment.id != null) {

                  Get.to(() => ContractView(shipmentId: shipment.id!));
                } else {
                  Get.snackbar("خطأ", "رقم الشحنة غير متوفر");
                }
              },
              onTracing: isOrderConfirmed ? () {
                if (shipment.id != null) {
                  Get.to(() => ShipmentTrackingView(shipmentId: shipment.id!));
                }
              }
                  : null,

              showStatus: isOrderConfirmed,
            );

          },
        );
      }),
    );
  }
}
