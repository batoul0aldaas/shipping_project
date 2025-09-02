import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shipment_tracking_controller.dart';
import '../model/shipment_tracking_model.dart';

class ShipmentTrackingView extends StatelessWidget {
  final int shipmentId;

  ShipmentTrackingView({required this.shipmentId});

  @override
  Widget build(BuildContext context) {
    final ShipmentTrackingController controller = Get.put(
        ShipmentTrackingController(shipmentId: shipmentId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'تتبع الشحنات',
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
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667EEA),
                  Color(0xFF764BA2),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.track_changes,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تتبع حالة الشحنة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'رقم الشحنة: $shipmentId',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Tracking Data
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF26A69A).withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF26A69A)),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'جاري تحميل بيانات التتبع...',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          size: 40,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFECACA),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDC2626),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.refreshData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF26A69A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'إعادة المحاولة',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () => controller.clearError(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF26A69A)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'إغلاق',
                              style: TextStyle(color: Color(0xFF26A69A)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              if (!controller.hasTrackingData) {
                return Center(
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
                        child: const Icon(
                          Icons.local_shipping_outlined,
                          size: 40,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'لا توجد بيانات تتبع',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ستظهر بيانات التتبع هنا عند توفرها',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  children: [
                    if (controller.trackingData!.routes.isNotEmpty) ...[
                      Text("روابط التتبع:", style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium),
                      const SizedBox(height: 12),
                      ...controller.trackingData!.routes.map((r) =>
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                  Icons.link, color: Color(0xFF26A69A)),
                              title: Text("Shipment ID: ${r.shipmentId}"),
                              subtitle: Text("Route ID: ${r.id}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.open_in_new,
                                    color: Color(0xFF26A69A)),
                                onPressed: () =>
                                    controller.openTrackingLink(r.trackingLink),
                              ),
                            ),
                          )),
                      const SizedBox(height: 20),
                    ],

                    if (controller.trackingData!.logs.isNotEmpty) ...[
                      Text("سجل التتبع:", style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium),
                      const SizedBox(height: 12),
                      ...controller.trackingData!.logs.map((l) =>
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                  Icons.history, color: Color(0xFF00897B)),
                              title: Text(l.status ?? "غير معروف"),
                              subtitle: Text(l.date ?? ""),
                            ),
                          )),
                    ],
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

}