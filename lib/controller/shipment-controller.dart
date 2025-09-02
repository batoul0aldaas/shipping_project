
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/CategoryModel.dart';
import '../model/DocumentModel.dart';
import '../model/QuestionModel.dart';
import '../model/ShipmentModel.dart';
import '../services/api_service.dart';
import '../services/api_shipment_service.dart';
import '../view/questions_view.dart';
import 'cart_controller.dart';


class ShipmentController extends GetxController {
  int? shipmentId;
  var isLoading = false.obs;
  final categories = <CategoryModel>[].obs;
  var selectedCategory = Rxn<CategoryModel>();
  var shipment = ShipmentModel();
  final serviceType = ''.obs;
  final shippingMethod = ''.obs;
  var isCategoryEmpty = false.obs;
  var isServiceTypeEmpty = false.obs;
  var isShippingMethodEmpty = false.obs;
  var isWeightEmpty = false.obs;
  var isDateEmpty = false.obs;
  var isDestinationEmpty = false.obs;
  var isSupplierFormInvalid = false.obs;

  final useSupplier = false.obs;
  PlatformFile? selectedFile;
  final supplierNameController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final supplierEmailController = TextEditingController();
  final supplierPhoneController = TextEditingController();
  final containersNumberController = TextEditingController();
  final numberController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final shippingDateController = TextEditingController();
  final weightController = TextEditingController();
  final containerSizeController = TextEditingController();
  final employeeNotesController = TextEditingController();
  final customerNotesController = TextEditingController();
  final List<String> serviceTypes = ['import', 'export'];
  final List<String> shippingMethods = ['sea', 'air', 'Land'];
  final TextEditingController fileController = TextEditingController();
  var shipments = <ShipmentModel>[].obs;
  var documents = <DocumentModel>[].obs;
   final List<TextEditingController> answersControllers = [];
  var questions = <QuestionModel>[].obs;

  int? orderId;

  ShipmentController({this.orderId});


  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  bool validateForm() {
    bool isValid = true;

    isCategoryEmpty.value = selectedCategory.value == null;
    isServiceTypeEmpty.value = serviceType.value.isEmpty;
    isShippingMethodEmpty.value = shippingMethod.value.isEmpty;
    isWeightEmpty.value = weightController.text.trim().isEmpty;
    isDateEmpty.value = shippingDateController.text.trim().isEmpty;
    isDestinationEmpty.value = destinationController.text.trim().isEmpty;

    if (isCategoryEmpty.value) {
      Get.snackbar("تنبيه", "يرجى اختيار الفئة");
      isValid = false;
    } else if (isServiceTypeEmpty.value) {
      Get.snackbar("تنبيه", "يرجى اختيار نوع الخدمة");
      isValid = false;
    } else if (isShippingMethodEmpty.value) {
      Get.snackbar("تنبيه", "يرجى اختيار طريقة الشحن");
      isValid = false;
    } else if (isWeightEmpty.value) {
      Get.snackbar("تنبيه", "يرجى إدخال وزن الشحنة");
      isValid = false;
    } else if (isDateEmpty.value) {
      Get.snackbar("تنبيه", "يرجى تحديد تاريخ الشحن");
      isValid = false;
    } else if (isDestinationEmpty.value) {
      Get.snackbar("تنبيه", "يرجى إدخال بلد الوصول");
      isValid = false;
    }
    if (useSupplier.value) {
      if (supplierNameController.text.trim().isEmpty ||
          supplierAddressController.text.trim().isEmpty ||
          supplierEmailController.text.trim().isEmpty ||
          supplierPhoneController.text.trim().isEmpty ||fileController.text.trim().isEmpty) {
        Get.snackbar("تنبيه", "يرجى ملء جميع بيانات المعمل");
        isValid = false;
        isSupplierFormInvalid.value = true;
      } else {
        isSupplierFormInvalid.value = false;
      }
    }
    return isValid;
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf','docx'],
    );

    if (result != null && result.files.single.path != null) {
      selectedFile = result.files.single;
      fileController.text = selectedFile!.name;
      Get.snackbar("تم", "تم اختيار الملف: ${selectedFile!.name}");
    } else {
      Get.snackbar("إلغاء", "لم يتم اختيار أي ملف");
    }
  }
  void submitShipmentAndSupplier() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      shipment = ShipmentModel(
        categoryId: selectedCategory.value?.id.toString(),
        shippingDate: shippingDateController.text.trim(),
        serviceType: serviceType.value,
        originCountry: originController.text.trim(),
        destinationCountry: destinationController.text.trim(),
        shippingMethod: shippingMethod.value,
        cargoWeight: weightController.text.trim(),
        containersSize: containerSizeController.text.trim(),
        containersNumbers: containersNumberController.text.trim(),
        employeeNotes: employeeNotesController.text.trim(),
        customerNotes: customerNotesController.text.trim(),
        havingSupplier: useSupplier.value ,
        supplierName: supplierNameController.text.trim(),
        supplierAddress: supplierAddressController.text.trim(),
        supplierEmail: supplierEmailController.text.trim(),
        supplierPhone: supplierPhoneController.text.trim(),
      );

      final shipmentResponse = await ApiShipmentService.postShipmentWithSupplier(
        shipment: shipment,
        platformFile: selectedFile,
      );

      if (shipmentResponse['status'] == 1) {
        final shipmentData = shipmentResponse['data']['shipment'];
        shipmentId = shipmentData['id'];
        final cartController = Get.find<CartController>();
        cartController.addShipment(shipment);
        Get.to(() => QuestionsView(
          categoryId: selectedCategory.value!.id,
          shipmentId: shipmentId!,
        ));
      } else {
        Get.snackbar("فشل", shipmentResponse['message'] ?? "حدث خطأ أثناء الإرسال");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالخادم: $e");
    } finally {
      isLoading.value = false;
    }
  }



  void fetchCategories() async {
    try {
      isLoading.value = true;
      final result = await ApiShipmentService.getCategories();
      categories.value = result;
    } catch (e) {
      print(" خطأ أثناء جلب الكاتيجوري: $e");
      Get.snackbar("خطأ", "فشل في تحميل الفئات");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchShipments([int? orderIdParam]) async {
    isLoading.value = true;
    try {
      final id = orderIdParam ?? orderId;
      if (id == null) {
        print("❌ orderId is null, can't fetch shipments.");
        return;
      }
      shipments.value = await ApiShipmentService.getShipmentsByOrderId(id);
    } catch (e) {
      print("Error loading shipments: $e");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> fetchShipmentFullData(int shipmentId) async {
    isLoading.value = true;
    try {
      final result = await ApiShipmentService.getFullShipmentById(shipmentId);


      if (result != null) {
        shipment = result;
        selectedCategory.value = categories.firstWhereOrNull(
              (cat) => cat.id.toString() == result.categoryId,
        );
        serviceType.value = result.serviceType ?? '';
        shippingMethod.value = result.shippingMethod ?? '';
        originController.text = result.originCountry ?? '';
        destinationController.text = result.destinationCountry ?? '';
        shippingDateController.text = result.shippingDate ?? '';
        weightController.text = result.cargoWeight ?? '';
        containerSizeController.text = result.containersSize ?? '';
        containersNumberController.text = result.containersNumbers ?? '';
        employeeNotesController.text = result.employeeNotes ?? '';
        customerNotesController.text = result.customerNotes ?? '';
        useSupplier.value = result.havingSupplier ?? false;

        if (useSupplier.value) {
          supplierNameController.text = result.supplierName ?? '';
          supplierAddressController.text = result.supplierAddress ?? '';
          supplierEmailController.text = result.supplierEmail ?? '';
          supplierPhoneController.text = result.supplierPhone ?? '';
        }

        documents.value = result.documents ?? [];

        final invoice = documents.firstWhereOrNull((doc) => doc.type == 'sup_invoice');
        if (invoice != null) {
          fileController.text = invoice.filePath?.split('/').last ?? 'تم رفع الملف';
        }

      answersControllers.clear();
      if (shipment.answers != null) {
        for (var answer in shipment.answers!) {
          answersControllers.add(TextEditingController(text: answer.answer));
        }}
      }
    } catch (e) {
      print("❗ Error in controller.fetchShipmentFullData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitEditedShipment(int shipmentId) async {
    isLoading.value = true;
    try {
      final shipment = ShipmentModel(
        categoryId: selectedCategory.value?.id.toString(),
        serviceType: serviceType.value,
        shippingMethod: shippingMethod.value,
        originCountry: originController.text,
        destinationCountry: destinationController.text,
        shippingDate: shippingDateController.text,
        cargoWeight: weightController.text,
        containersSize: containerSizeController.text,
        containersNumbers: containersNumberController.text,
        employeeNotes: employeeNotesController.text,
        customerNotes: customerNotesController.text,
        havingSupplier: useSupplier.value,
        supplierName: useSupplier.value ? supplierNameController.text : null,
        supplierAddress: useSupplier.value ? supplierAddressController.text : null,
        supplierEmail: useSupplier.value ? supplierEmailController.text : null,
        supplierPhone: useSupplier.value ? supplierPhoneController.text : null,
        answers: this.shipment.answers,
      );

      if (shipment.answers != null) {
        for (int i = 0; i < shipment.answers!.length; i++) {
          shipment.answers![i].answer = answersControllers[i].text.trim();
        }
      }
      final success = await ApiShipmentService.postEditShipment(
        shipmentId: shipmentId,
        shipment: shipment,
        file: selectedFile,
      );

      if (success) {
        Get.snackbar("تم", "تم تعديل الشحنة بنجاح");
      } else {
        Get.snackbar("خطأ", "فشل تعديل الشحنة");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFile2() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      selectedFile = result.files.first;
      fileController.text = selectedFile!.name;
    }
  }

  Future<void> confirmShipment(int shipmentId) async {
    final success = await ApiShipmentService.confirmShipment(shipmentId);
    if (success) {
      Get.snackbar("تم", "تم تأكيد الشحنة بنجاح");
      fetchShipments();
    } else {
      Get.snackbar("خطأ", "فشل في تأكيد الشحنة");
    }
  }

  Future<void> deleteShipment(int shipmentId) async {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد من حذف هذه الشحنة؟",
      textCancel: "إلغاء",
      textConfirm: "حذف",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF334EAC),
      onConfirm: () async {
        Get.back();
        final success = await ApiShipmentService.deleteShipment(shipmentId);
        if (success) {
          Get.snackbar("تم", "تم حذف الشحنة بنجاح");
          fetchShipments(orderId);
        } else {
          Get.snackbar("خطأ", "فشل حذف الشحنة");
        }
      },
    );
  }



}
