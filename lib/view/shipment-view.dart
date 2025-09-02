
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shipment-controller.dart';
import '../model/CategoryModel.dart';
import '../widgets/custom_date_field.dart';
import '../widgets/custom_dropdown_form_field.dart';
import '../widgets/custom_text_field.dart';

class ShipmentView extends StatelessWidget {
  const ShipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShipmentController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'shipment_data'.tr,
          style: const TextStyle(
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
      body:Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
            ),
          ),
        );
      }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/Bill-of-LP-Image-1.webp",
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "new_shipment".tr,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "fill_form".tr,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                Obx(
                      () => CustomDropdownFormField<CategoryModel>(
                    label: "category".tr,
                    value: controller.selectedCategory.value,
                    items: controller.categories,
                    getLabel: (cat) => cat.name,
                    onChanged: (cat) => controller.selectedCategory.value = cat,
                    isError: controller.isCategoryEmpty.value,
                  ),
                ),

                const SizedBox(height: 16),

                Obx(
                      () => CustomDropdownFormField<String>(
                    label: "service_type".tr,
                    value: controller.serviceType.value.isEmpty
                        ? null
                        : controller.serviceType.value,
                    items: controller.serviceTypes,
                    getLabel: (type) => type == 'import' ? 'استيراد' : 'تصدير',
                    onChanged: (val) =>
                    controller.serviceType.value = val ?? '',
                    getIcon: (type) => type == 'import'
                        ? Icons.call_received
                        : Icons.call_made,
                    isError: controller.isServiceTypeEmpty.value,
                  ),
                ),
                const SizedBox(height: 16),

                Obx(
                      () => CustomDropdownFormField<String>(
                    label: "shipping_method".tr,
                    value: controller.shippingMethod.value.isEmpty
                        ? null
                        : controller.shippingMethod.value,
                    items: controller.shippingMethods,
                    getLabel: (method) => method == 'sea'
                        ? 'بحري'
                        : method == 'air'
                        ? 'جوي'
                        : 'بري',
                    onChanged: (val) =>
                    controller.shippingMethod.value = val ?? '',
                    getIcon: (method) => method == 'sea'
                        ? Icons.sailing
                        : method == 'air'
                        ? Icons.flight
                        : Icons.local_shipping,
                    isError: controller.isShippingMethodEmpty.value,
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: "origin_country".tr,
                  controller: controller.originController,
                  keyboardType: TextInputType.text,
                ),
                CustomTextField(
                  label: "destination_country".tr,
                  controller: controller.destinationController,
                  keyboardType: TextInputType.text,
                  isError: controller.isDestinationEmpty.value,
                ),
                CustomDateField(
                  label: "shipping_date".tr,
                  controller: controller.shippingDateController,
                  isError: controller.isDateEmpty.value,
                ),
                CustomTextField(
                  label: "weight".tr,
                  controller: controller.weightController,
                  keyboardType: TextInputType.number,
                  isError: controller.isWeightEmpty.value,
                ),
                CustomTextField(
                  label: "container_size".tr,
                  controller: controller.containerSizeController,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  label: "containers_number".tr,
                  controller: controller.containersNumberController,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  label: "employee_notes".tr,
                  controller: controller.employeeNotesController,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                ),
                CustomTextField(
                  label: "customer_notes".tr,
                  controller: controller.customerNotesController,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Obx(
                        () => SwitchListTile(
                      title: Text(
                        "use_supplier".tr,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "toggle_supplier_info".tr,
                        style: TextStyle(
                          color: const Color(0xFF64748B).withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      value: controller.useSupplier.value,
                      onChanged: (val) => controller.useSupplier.value = val,
                      activeColor: const Color(0xFF667EEA),
                      activeTrackColor: const Color(0xFF667EEA).withOpacity(0.3),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                Obx(() {
                  if (!controller.useSupplier.value) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF667EEA).withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF667EEA),
                                    Color(0xFF764BA2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.business_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "supplier_info".tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: "supplier_name".tr,
                          controller: controller.supplierNameController,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.drive_file_rename_outline,
                        ),
                        CustomTextField(
                          label: "supplier_address".tr,
                          controller: controller.supplierAddressController,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.location_city_outlined,
                        ),
                        CustomTextField(
                          label: "supplier_email".tr,
                          controller: controller.supplierEmailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                        ),
                        CustomTextField(
                          label: "supplier_phone".tr,
                          controller: controller.supplierPhoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_android_outlined,
                        ),
                        GestureDetector(
                          onTap: controller.pickFile,
                          child: AbsorbPointer(
                            child: CustomTextField(
                              label: "invoice_file".tr,
                              controller: controller.fileController,
                              prefixIcon: Icons.attach_file,
                              readOnly: true,
                              hintText: "pick_file".tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667EEA),
                        Color(0xFF764BA2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: controller.isLoading.value
                      ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                      : ElevatedButton(
                    onPressed: controller.submitShipmentAndSupplier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "next".tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}
