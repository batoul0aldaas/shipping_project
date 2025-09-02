class QuestionModel {
  final int id;
  final String type;
  final String question;
  final List<OptionModel> options;

  QuestionModel({
  required this.id,
  required this.type,
  required this.question,
  required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
  return QuestionModel(
  id: json['id'],
  type: json['type'],
  question: json['question'] ?? '',
  options: (json['options'] as List)
      .map((e) => OptionModel.fromJson(e))
      .toList(),
  );
  }
  }


class OptionModel {
  final int id;
  final String value;

  OptionModel({required this.id, required this.value});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      value: json['value'] ?? '',
    );
  }
}
