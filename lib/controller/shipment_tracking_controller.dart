// lib/controller/shipment_tracking_controller.dart
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/shipment_tracking_model.dart';
import '../services/api_shipment_tracking_service.dart';

class ShipmentTrackingController extends GetxController {
  final int shipmentId;
  ShipmentTrackingController({required this.shipmentId});

  var isLoading = false.obs;
  var errorMessage = "".obs;
  ShipmentTrackingModel? trackingData;

  bool get hasTrackingData => trackingData != null;

  @override
  void onInit() {
    super.onInit();
    fetchTrackingData();
  }

  Future<void> fetchTrackingData() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      trackingData = await ShipmentTrackingService.fetchTracking(shipmentId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async => fetchTrackingData();

  void clearError() => errorMessage.value = "";

  Future<void> openTrackingLink(String url) async {
    final uri = Uri.parse(url.trim());

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar("خطأ", "فشل فتح الرابط: $url");
    }
  }

}
