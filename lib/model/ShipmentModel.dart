

import 'AnswerModel.dart';
import 'DocumentModel.dart';

class ShipmentModel {
  int? id;
  String? categoryId;
  String? number;
  String? shippingDate;
  String? serviceType;
  String? originCountry;
  String? destinationCountry;
  String? shippingMethod;
  String? cargoWeight;
  String? containersSize;
  String? containersNumbers;
  String? employeeNotes;
  String? customerNotes;
  bool? havingSupplier;
  String? supplierName;
  String? supplierAddress;
  String? supplierEmail;
  String? supplierPhone;
  List<DocumentModel>? documents;
  List<AnswerModel>? answers;
  bool? isConfirmed;
  String? status;

  ShipmentModel({
    this.id,
    this.categoryId,
    this.number,
    this.shippingDate,
    this.serviceType,
    this.originCountry,
    this.destinationCountry,
    this.shippingMethod,
    this.cargoWeight,
    this.containersSize,
    this.containersNumbers,
    this.employeeNotes,
    this.customerNotes,
    this.havingSupplier,
    this.supplierAddress,
    this.supplierEmail,
    this.supplierName,
    this.supplierPhone,
    this.documents,
    this.answers,
    this.isConfirmed,
    this.status,
  });


  Map<String, dynamic> toJson() {
    final data = {
      'category_id': categoryId,
      'shipping_date': shippingDate,
      'service_type': serviceType,
      'origin_country': originCountry,
      'destination_country': destinationCountry,
      'shipping_method': shippingMethod,
      'cargo_weight': cargoWeight,
      'containers_size': containersSize,
      'containers_numbers': containersNumbers,
      'employee_notes': employeeNotes,
      'customer_notes': customerNotes,
      'having_supplier': havingSupplier,
    };

    if (havingSupplier == true) {
      data.addAll({
        'supplier[name]': supplierName,
        'supplier[address]': supplierAddress,
        'supplier[contact_email]': supplierEmail,
        'supplier[contact_phone]': supplierPhone,
      });
    }

    return data;
  }

  Map<String, dynamic> toJson2() {
    final data = {
      'category_id': categoryId,
      'shipping_date': shippingDate,
      'service_type': serviceType,
      'origin_country': originCountry,
      'destination_country': destinationCountry,
      'shipping_method': shippingMethod,
      'cargo_weight': cargoWeight,
      'employee_notes': employeeNotes,
      'customer_notes': customerNotes,
      'having_supplier': havingSupplier,
    };

    if (containersSize != null && containersSize!.trim().isNotEmpty) {
      data['containers_size'] = int.tryParse(containersSize!);
    }

    if (containersNumbers != null && containersNumbers!.trim().isNotEmpty) {
      data['containers_numbers'] = int.tryParse(containersNumbers!);
    }

    if (havingSupplier == true) {
      data.addAll({
        'supplier[name]': supplierName,
        'supplier[address]': supplierAddress,
        'supplier[contact_email]': supplierEmail,
        'supplier[contact_phone]': supplierPhone,
      });
    }

    if (answers != null) {
      for (int i = 0; i < answers!.length; i++) {
        data.addAll(answers![i].toJson(i));
      }
    }

    return data;
  }

  factory ShipmentModel.fromJson(Map<String, dynamic> json, {
    Map<String, dynamic>? supplier,
    List<dynamic>? documentsJson,
    List<dynamic>? answersJson,
  }) {
    return ShipmentModel(
      id: json['id'],
      categoryId: json['category_id']?.toString(),
      number: json['number'],
      shippingDate: json['shipping_date'],
      serviceType: json['service_type'],
      originCountry: json['origin_country'],
      destinationCountry: json['destination_country'],
      shippingMethod: json['shipping_method'],
      cargoWeight: json['cargo_weight']?.toString(),
      containersSize: json['containers_size']?.toString(),
      containersNumbers: json['containers_numbers']?.toString(),
      employeeNotes: json['employee_notes'],
      customerNotes: json['customer_notes'],
      havingSupplier: json['having_supplier'] == 1,
      supplierName: supplier?['name'],
      supplierAddress: supplier?['address'],
      supplierEmail: supplier?['contact_email'],
      supplierPhone: supplier?['contact_phone']?.toString(),
      documents: documentsJson?.map((e) => DocumentModel.fromJson(e)).toList(),
      answers: answersJson?.map((e) => AnswerModel.fromJson(e)).toList(),
      isConfirmed: json['is_confirm'] == 1,
        status: json['status'],
    );
  }


}




