class OrderModel {
  final int id;
  final int customerId;
  final String orderNumber;
  final int status;
  final int? originalCompanyId;
  final String? orderStatus;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.orderNumber,
    required this.status,
    this.originalCompanyId,
    this.orderStatus,

  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerId: json['customer_id'],
      orderNumber: json['order_number'],
      status: json['status'],
      originalCompanyId: json['original_company_id'],
      orderStatus: json['order_status'],
    );
  }
}
