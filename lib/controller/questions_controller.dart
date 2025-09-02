import 'package:get/get.dart';
import '../model/AnswerModel.dart';
import '../model/QuestionModel.dart';
import '../services/api_service.dart';
import '../services/api_shipment_service.dart';

class QuestionsController extends GetxController {
  final int categoryId;
  QuestionsController(this.categoryId);

  var isLoading = false.obs;
  var questions = <QuestionModel>[].obs;
  var error = RxnString();


  @override
  void onInit() {
    fetchQuestions();
    super.onInit();

  }

  void fetchQuestions() async {
    isLoading.value = true;
    error.value = null;
    try {
      final result = await ApiShipmentService.getQuestionsByCategory(categoryId);
      questions.value = result;
      if (result.isEmpty) {
        error.value = 'لا توجد أسئلة متاحة لهذا التصنيف.';
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب الأسئلة: $e");
      error.value = 'فشل في جلب الأسئلة';
    } finally {
      isLoading.value = false;
    }
  }
}