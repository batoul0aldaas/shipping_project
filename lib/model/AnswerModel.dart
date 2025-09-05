import 'package:ba11/model/QuestionModel.dart';

class AnswerModel {
  int? id;
  dynamic answer;
  QuestionModel question;

  AnswerModel({this.id, this.answer, required this.question});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    dynamic parsedAnswer = json['answer'];
    final type = json['question']['type'];

    if (type == "checkbox") {
      if (parsedAnswer is List) {
        parsedAnswer = parsedAnswer.map((e) => int.tryParse(e.toString()) ?? 0).toList();
      } else if (parsedAnswer is String && parsedAnswer.isNotEmpty) {
        parsedAnswer = parsedAnswer.split(',').map((e) => int.tryParse(e) ?? 0).toList();
      } else if (parsedAnswer is int) {
        parsedAnswer = [parsedAnswer];
      } else {
        parsedAnswer = <int>[];
      }
    } else if (type == "radio" || type == "select") {
      if (parsedAnswer is String && parsedAnswer.isNotEmpty) {
        parsedAnswer = int.tryParse(parsedAnswer);
      }
    } else {
      parsedAnswer = parsedAnswer?.toString() ?? '';
    }

    return AnswerModel(
      id: json['id'],
      answer: parsedAnswer,
      question: QuestionModel.fromJson(json['question']),
    );
  }

  Map<String, dynamic> toJson(int index) {
    if (question.type == "checkbox") {
      final list = (answer is List) ? answer as List : [];
      return {
        'answers[$index][id]': id.toString(),
        'answers[$index][answer]': list.isNotEmpty ? list.join(',') : '',
      };
    } else {
      return {
        'answers[$index][id]': id.toString(),
        'answers[$index][answer]': answer?.toString() ?? '',
      };
    }
  }
}
