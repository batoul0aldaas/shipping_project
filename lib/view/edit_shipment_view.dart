import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/shipment-controller.dart';
import '../model/CategoryModel.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_date_field.dart';
import '../widgets/custom_dropdown_form_field.dart';
import '../widgets/file_preview_page.dart';
import '../widgets/universal_file_previewPage.dart';

class EditShipmentView extends StatelessWidget {
  final int shipmentId;


  const EditShipmentView({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShipmentController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchShipmentFullData(shipmentId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'تعديل بيانات الشحنة',
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "يرجى تعديل البيانات بدقة",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  Obx(
                    () => CustomDropdownFormField<CategoryModel>(
                      label: "الفئة",
                      value: controller.selectedCategory.value,
                      items: controller.categories,
                      getLabel: (cat) => cat.name,
                      onChanged: (cat) =>
                          controller.selectedCategory.value = cat,
                      isError: controller.isCategoryEmpty.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => CustomDropdownFormField<String>(
                      label: "نوع الخدمة",
                      value: controller.serviceType.value.isEmpty
                          ? null
                          : controller.serviceType.value,
                      items: controller.serviceTypes,
                      getLabel: (val) => val == 'import' ? 'استيراد' : 'تصدير',
                      onChanged: (val) =>
                          controller.serviceType.value = val ?? '',
                      getIcon: (val) => val == 'import'
                          ? Icons.call_received
                          : Icons.call_made,
                      isError: controller.isServiceTypeEmpty.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => CustomDropdownFormField<String>(
                      label: "طريقة الشحن",
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
                    label: "بلد المنشأ",
                    controller: controller.originController,
                  ),
                  CustomTextField(
                    label: "بلد الوصول",
                    controller: controller.destinationController,
                  ),
                  CustomDateField(
                    label: "تاريخ الشحن",
                    controller: controller.shippingDateController,
                  ),
                  CustomTextField(
                    label: "وزن الشحنة",
                    controller: controller.weightController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: "حجم الحاوية",
                    controller: controller.containerSizeController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: "عدد الحاويات",
                    controller: controller.containersNumberController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: "ملاحظات الموظف",
                    controller: controller.employeeNotesController,
                    maxLines: 2,
                    readOnly: true,
                  ),
                  CustomTextField(
                    label: "ملاحظات العميل",
                    controller: controller.customerNotesController,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 16),

                  Obx(
                    () => SwitchListTile(
                      title: const Text("هل يوجد معمل (مورد)؟"),
                      value: controller.useSupplier.value,
                      onChanged: (val) => controller.useSupplier.value = val,
                      activeColor: const Color(0xFF334EAC),
                    ),
                  ),
                  if (controller.useSupplier.value) ...[
                    const SizedBox(height: 8),
                    const Text(
                      "بيانات المعمل",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CustomTextField(
                      label: "اسم المعمل",
                      controller: controller.supplierNameController,
                    ),
                    CustomTextField(
                      label: "عنوان المعمل",
                      controller: controller.supplierAddressController,
                    ),
                    CustomTextField(
                      label: "البريد الإلكتروني",
                      controller: controller.supplierEmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      label: "رقم التواصل",
                      controller: controller.supplierPhoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    if (controller.fileController.text.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.insert_drive_file,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(controller.fileController.text)),
                          TextButton(
                            onPressed: () {
                              final doc = controller.documents.firstWhereOrNull(
                                    (d) => d.type == 'sup_invoice',
                              );
                              if (doc != null && doc.filePath != null) {
                                final fullUrl =
                                    "https://pink-scorpion-423797.hostingersite.com/public/${doc.filePath}";
                                Get.to(
                                      () => UniversalFilePreviewPage(fileUrl: fullUrl,),
                                );
                              }
                            },
                            child: const Text("عرض الملف"),
                          ),
                        ],
                      ),
                  ],

                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: controller.pickFile,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: "ملف الفاتورة",
                        controller: controller.fileController,
                        prefixIcon: Icons.attach_file,
                        readOnly: true,
                        hintText: "اضغط لاختيار ملف",
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if ((controller.shipment.answers?.isNotEmpty ?? false)) ...[
                    const Text(
                      " الأسئلة الخاصة بالتصنيف ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...controller.shipment.answers!.asMap().entries.map((
                      entry,
                    ) {
                      final index = entry.key;
                      final answer = entry.value;
                      return CustomTextField(
                        label: answer.question,
                        controller: controller.answersControllers[index],
                      );
                    }).toList(),
                  ],


                  const SizedBox(height: 24),

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
                      onPressed:()=> controller.submitEditedShipment(shipmentId),
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
                            'save-update'.tr,
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
