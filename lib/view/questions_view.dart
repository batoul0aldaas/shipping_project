
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controller/questions_controller.dart';
import '../services/api_service.dart';
import '../services/api_shipment_service.dart';
import '../widgets/custom_dropdown_form_field.dart';
import 'home_page.dart';

class QuestionsView extends StatelessWidget {
  final int categoryId;
  final int shipmentId;
  const QuestionsView({super.key, required this.categoryId, required this.shipmentId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionsController(categoryId));
    final answers = <int, dynamic>{}.obs;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
              ],
            ),
          ),
        ),
      ),
      body:Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            ),
          );
        }
        if (controller.error.value != null) {
          return Center(child: Text(controller.error.value!));
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/Bill-of-LP-Image-1.webp",
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                 Text(
                  'please_fill_questions'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Angkor', ),
                ),
                const SizedBox(height: 8),
                 Text(
                  'these_questions_required'.tr,
                  style: TextStyle(color: Colors.grey,fontSize: 16,fontFamily: 'Caveat'),
                ),
                const SizedBox(height: 24),
                ...controller.questions.map((q) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Obx(() => buildQuestionField(
                      q: q,
                      answer: answers[q.id],
                      onChanged: (val) => answers[q.id] = val,
                    )),
                  )
                ).toList(),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667EEA),
                        Color(0xFF764BA2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: controller.isLoading.value
                      ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                      : ElevatedButton(
                    onPressed: () async {
                      final answersList = answers.entries.map((entry) {
                        return {
                          'question_id': entry.key,
                          'answer': entry.value,
                        };
                      }).toList();

                      await ApiShipmentService.postShipmentAnswers(
                        shipmentId: shipmentId,
                        answers: answersList,
                      );

                      Get.offAll(() => HomePage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.outbond_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'send-shipment'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

