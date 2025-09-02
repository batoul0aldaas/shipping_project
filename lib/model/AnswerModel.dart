class AnswerModel {
  final int id;
  final int shipmentId;
  final String question;
   String? answer;

  AnswerModel({
    required this.id,
    required this.shipmentId,
    required this.question,
    required this.answer,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'],
      shipmentId: json['shipment_id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
