import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingDialog {
  static void show(
      BuildContext context,
      int orderId,
      Future<bool> Function(int, int, int) onRate,
      ) {
    int employeeRate = 0;
    int serviceRate = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget buildStars(
                int currentValue,
                void Function(int) onSelect,
                String label,
                IconData icon,
                ) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF667EEA).withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isSelected = starIndex <= currentValue;
                        return GestureDetector(
                          onTap: () => setState(() => onSelect(starIndex)),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedScale(
                              scale: isSelected ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutBack,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                  )
                                      : null,
                                  color: isSelected ? null : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: const Color(0xFF667EEA).withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                      : null,
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: isSelected ? Colors.white : Colors.grey.shade400,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.star_rate_rounded, size: 30, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "قيّم تجربتك",
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "ساعدنا في تحسين خدماتنا",
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          buildStars(employeeRate, (v) => employeeRate = v, "تقييم الموظف", Icons.person_rounded),
                          buildStars(serviceRate, (v) => serviceRate = v, "تقييم الخدمة", Icons.room_service_rounded),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF667EEA).withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: const Text(
                                      "إلغاء",
                                      style: TextStyle(color: Color(0xFF667EEA), fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF667EEA).withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (employeeRate > 0 && serviceRate > 0) {
                                        // Show loader
                                        Get.dialog(
                                          const Center(child: CircularProgressIndicator()),
                                          barrierDismissible: false,
                                        );

                                        final success = await onRate(orderId, employeeRate, serviceRate);

                                        Get.back();

                                        if (success) {
                                          Get.snackbar(
                                            "شكراً لك!",
                                            "تم إرسال تقييمك بنجاح",
                                            backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
                                            colorText: const Color(0xFF10B981),
                                            icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                                            snackPosition: SnackPosition.TOP,
                                            borderRadius: 16,
                                            margin: const EdgeInsets.all(16),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          Get.snackbar(
                                            "خطأ",
                                            "حدث خطأ أثناء إرسال التقييم",
                                            backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                                            colorText: const Color(0xFFEF4444),
                                            icon: const Icon(Icons.error_rounded, color: Color(0xFFEF4444)),
                                            snackPosition: SnackPosition.TOP,
                                            borderRadius: 16,
                                            margin: const EdgeInsets.all(16),
                                          );
                                        }
                                      } else {
                                        Get.snackbar(
                                          "تنبيه",
                                          "الرجاء اختيار تقييم كامل",
                                          backgroundColor: Colors.orange.withOpacity(0.1),
                                          colorText: Colors.orange.shade700,
                                          icon: Icon(Icons.warning_rounded, color: Colors.orange.shade700),
                                          snackPosition: SnackPosition.TOP,
                                          borderRadius: 16,
                                          margin: const EdgeInsets.all(16),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          "إرسال التقييم",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
