import 'dart:io';
import 'package:get/get.dart';
import '../model/contract_model.dart';
import '../services/contract_service.dart';

class ContractController extends GetxController {
  final int shipmentId;
  ContractController({required this.shipmentId});

  var contracts = <Contract>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContracts();
  }

  void fetchContracts() async {
    isLoading.value = true;
    contracts.value = await ContractService.fetchContracts(shipmentId);
    isLoading.value = false;
  }

  void downloadContract(Contract contract) {
    ContractService.downloadContract(contract);
  }

  void uploadSignedContract(File file) {
    ContractService.uploadSignedContract(shipmentId, file).then((_) {
      fetchContracts();
    });
  }
}
