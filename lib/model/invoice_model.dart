class InvoiceModel {
  final int id;
  final int invoiceNumber;
  final String invoiceType;
  final int initialAmount;
  final int customsFee;
  final int serviceFee;
  final int companyProfit;
  final int finalAmount;
  final String notes;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceType,
    required this.initialAmount,
    required this.customsFee,
    required this.serviceFee,
    required this.companyProfit,
    required this.finalAmount,
    required this.notes,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      invoiceType: json['invoice_type'],
      initialAmount: json['initial_amount'],
      customsFee: json['customs_fee'],
      serviceFee: json['service_fee'],
      companyProfit: json['company_profit'],
      finalAmount: json['final_amount'],
      notes: json['notes'],
    );
  }
}
