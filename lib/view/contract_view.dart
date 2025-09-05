import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../controller/contract_controller.dart';
import '../model/contract_model.dart';

class ContractView extends StatelessWidget {
  final int shipmentId;
  ContractView({required this.shipmentId});

  final RxString selectedFilter = "all".obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController(shipmentId: shipmentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("عقود الشحنة", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildFilterChip("all", "الكل", selectedFilter.value),
                _buildFilterChip("signed", "موقّع", selectedFilter.value),
                _buildFilterChip("final", "نهائي", selectedFilter.value),
                _buildFilterChip("pending", "معلق", selectedFilter.value),
                _buildFilterChip("canceled", "ملغي", selectedFilter.value),
              ],
            ),
          )),


          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.contracts.isEmpty) {
                return const Center(child: Text("لا توجد عقود لهذا الشحنة"));
              }

              final filteredContracts = selectedFilter.value == "all"
                  ? controller.contracts
                  : controller.contracts
                  .where((c) => c.status.toLowerCase() == selectedFilter.value)
                  .toList();

              if (filteredContracts.isEmpty) {
                return const Center(child: Text("لا توجد عقود في هذه الحالة"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredContracts.length,
                itemBuilder: (context, index) {
                  final Contract contract = filteredContracts[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF667EEA),
                        child: const Icon(Icons.description_rounded, color: Colors.white),
                      ),
                      title: Text(
                        contract.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B)),
                      ),
                      subtitle: Text(
                        "${contract.typeLabel} • ${contract.statusLabel}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(contract.status),
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 6,
                        children: [
                          _buildGradientButton(
                            label: "تحميل",
                            icon: Icons.download_rounded,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onPressed: () => controller.downloadContract(contract),
                          ),
                          if (contract.type == "service" &&
                              contract.status != "signed")
                            _buildGradientButton(
                              label: "رفع",
                              icon: Icons.upload_file_rounded,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF764BA2), Color(0xFF667EEA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onPressed: () async {
                                FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  controller.uploadSignedContract(file);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, String selected) {
    final isSelected = selected == value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF667EEA) : const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => selectedFilter.value = value,
        selectedColor: Colors.white,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFF667EEA) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
      ),
    );
  }


  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "signed":
        return Colors.green;
      case "final":
        return const Color(0xFF764BA2);
      case "pending":
        return Colors.orange;
      case "canceled":
        return Colors.red;
      default:
        return const Color(0xFF64748B);
    }
  }
}
