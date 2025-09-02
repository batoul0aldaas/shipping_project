import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/ShipmentModel.dart';
import '../services/api_shipment_service.dart';


/*class CartController extends GetxController{

  var shipments = <Shipment>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadShipments();
  }

  void loadShipments() async {
    try {
      isLoading(true);
      final result = await ApiShipmentService.fetchCartShipments();
      shipments.assignAll(result);
      print("عدد الشحنات المستلمة: ${result.length}");
    } catch (e) {
      print("Error loading shipments: $e");
    } finally {
      isLoading(false);
    }
  }
}*/
// cart_controller.dart



class CartController extends GetxController {
  final box = GetStorage();
  var shipments = <ShipmentModel>[].obs;
  var isSending = false.obs;

  final _storageKey = "cart_shipments";

  @override
  void onInit() {
    super.onInit();
    loadShipments();
  }

  void addShipment(ShipmentModel shipment) {
    shipments.add(shipment);
    saveShipments();
  }

  void removeShipment(int index) {
    shipments.removeAt(index);
    saveShipments();
  }

  void clearCart() {
    shipments.clear();
    saveShipments();
  }

  void saveShipments() {
    final list = shipments.map((s) => jsonEncode(s.toJson())).toList();
    box.write(_storageKey, list);
  }

  void loadShipments() {
    final storedList = box.read<List>(_storageKey) ?? [];
    shipments.value = storedList.map((item) {
      final json = jsonDecode(item);
      return ShipmentModel(
        categoryId: json['category_id'],
        number: json['number'],
        originCountry: json['origin_country'],
        destinationCountry: json['destination_country'],
        shippingDate: json['shipping_date'],
        shippingMethod: json['shipping_method'],
        serviceType: json['service_type'],
        cargoWeight: json['cargo_weight'],
        containersSize: json['containers_size'],
        containersNumbers: json['containers_numbers'],
      );
    }).toList();
  }


  Future<void> sendCartShipments() async {
    isSending.value = true;
    try {
      await ApiShipmentService.sendCart();
      clearCart();

      Get.snackbar(
        "تم الإرسال",
        "تم إرسال الشحنات بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent.shade100,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "فشل الإرسال",
        "حدث خطأ أثناء إرسال الشحنات",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade200,
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

}

