class DocumentModel {
  final int id;
  final int shipmentId;
  final String type;
  final String filePath;
  final String uploadedBy;
  final bool visibleToCustomer;

  DocumentModel({
    required this.id,
    required this.shipmentId,
    required this.type,
    required this.filePath,
    required this.uploadedBy,
    required this.visibleToCustomer,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      shipmentId: json['shipment_id'],
      type: json['type'],
      filePath: json['file_path'],
      uploadedBy: json['uploaded_by'].toString(),
      visibleToCustomer: json['visible_to_customer'] == 1,
    );
  }
}
