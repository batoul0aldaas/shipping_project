class InvoiceOrderModel {
  final int id;
  final int invoiceNumber;
  final double totalInitialAmount;
  final double totalCustomsFee;
  final double totalServiceFee;
  final double totalCompanyProfit;
  final double totalFinalAmount;
  final String notes;
  final double nextPaymentAmount;
  final String paymentStatus;

  InvoiceOrderModel({
    required this.id,
    required this.invoiceNumber,
    required this.totalInitialAmount,
    required this.totalCustomsFee,
    required this.totalServiceFee,
    required this.totalCompanyProfit,
    required this.totalFinalAmount,
    required this.notes,
    required this.nextPaymentAmount,
    required this.paymentStatus,
  });

  factory InvoiceOrderModel.fromJson(Map<String, dynamic> json) {
    return InvoiceOrderModel(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      totalInitialAmount: (json['total_initial_amount'] as num).toDouble(),
      totalCustomsFee: (json['total_customs_fee'] as num).toDouble(),
      totalServiceFee: (json['total_service_fee'] as num).toDouble(),
      totalCompanyProfit: (json['total_company_profit'] as num).toDouble(),
      totalFinalAmount: (json['total_final_amount'] as num).toDouble(),
      notes: json['notes'] ?? '',
      nextPaymentAmount: (json['next_payment_amount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['payment_status'] ?? 'غير محدد',
    );
  }
}
