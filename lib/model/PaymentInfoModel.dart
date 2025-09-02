class PaymentInfo {
  final int id;
  final String status;
  final String currency;
  final double paidAmount;
  final double dueAmount;
  final String? paidAt;
  final String? dueDate;
  final String nextPaymentPhase;
  final double nextPaymentAmount;

  PaymentInfo({
    required this.id,
    required this.status,
    required this.currency,
    required this.paidAmount,
    required this.dueAmount,
    this.paidAt,
    this.dueDate,
    required this.nextPaymentPhase,
    required this.nextPaymentAmount,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      currency: json['currency'] ?? '',
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      dueAmount: (json['due_amount'] ?? 0).toDouble(),
      paidAt: json['paid_at'],
      dueDate: json['due_date'],
      nextPaymentPhase: json['next_payment_phase'] ?? '',
      nextPaymentAmount: (json['next_payment_amount'] ?? 0).toDouble(),
    );
  }
}

class PaymentInfoResponse {
  final int status;
  final String message;
  final PaymentInfo data;

  PaymentInfoResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentInfoResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInfoResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: PaymentInfo.fromJson(json['data']['info']),
    );
  }
}
