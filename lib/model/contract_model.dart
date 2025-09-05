class Contract {
  final int id;
  final int shipmentId;
  final String type;
  final String typeLabel;
  final String title;
  final String status;
  final String statusLabel;
  final String unsignedFileUrl;
  final String? signedFileUrl;

  Contract({
    required this.id,
    required this.shipmentId,
    required this.type,
    required this.typeLabel,
    required this.title,
    required this.status,
    required this.statusLabel,
    required this.unsignedFileUrl,
    this.signedFileUrl,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      shipmentId: json['shipment_id'],
      type: json['type'],
      typeLabel: json['type_label'],
      title: json['title'],
      status: json['status'],
      statusLabel: json['status_label'],
      unsignedFileUrl: json['unsigned_file_url'],
      signedFileUrl: json['signed_file_url'],
    );
  }
}
