import 'package:ba11/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_api_service.dart';
import '../services/api_service.dart';
import '../view/login_view.dart';
import '../view/complaint_view.dart';
import '../view/complaints_list_view.dart';
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _complaintsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8FAFC),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 280,
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
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'side_menu'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'welcome_back'.tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDrawerItem(
            icon: Icons.person_rounded,
            title: 'profile'.tr,
            color: const Color(0xFF667EEA),
            onTap: () {
              Get.back();
              Get.to(() => const ProfileView());
            },
          ),
          _buildDrawerItem(
            icon: Icons.language_rounded,
            title: 'change_language'.tr,
            color: const Color(0xFF764BA2),
            onTap: () {
              final currentLocale = Get.locale?.languageCode ?? 'ar';
              final newLocale =
              currentLocale == 'ar' ? const Locale('en') : const Locale('ar');
              Get.updateLocale(newLocale);
              Get.back();

              Get.snackbar(
                "language_changed".tr,
                "language_updated_successfully".tr,
                backgroundColor: const Color(0xFF667EEA).withOpacity(0.1),
                colorText: const Color(0xFF667EEA),
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF667EEA),
                ),
                snackPosition: SnackPosition.TOP,
                borderRadius: 16,
                margin: const EdgeInsets.all(16),
              );
            },
          ),
          const SizedBox(height: 20),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF334EAC).withOpacity(0.1),
                      const Color(0xFF334EAC).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.report_problem_rounded,
                  color: Color(0xFF334EAC),
                  size: 18,
                ),
              ),
              title: const Text(
                "شكاوي",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF334EAC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _complaintsExpanded
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: const Color(0xFF334EAC),
                  size: 14,
                ),
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              childrenPadding: const EdgeInsets.only(left: 32, right: 45),
              children: [
                ListTile(
                  leading: const Icon(Icons.send_rounded, color: Color(0xFF334EAC)),
                  title: const Text("إرسال شكوى"),
                  onTap: () {
                    Get.back();
                    Get.to(() =>  ComplaintView());
                  },
                  tileColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
                ListTile(
                  leading: const Icon(Icons.list_rounded, color: Color(0xFF334EAC)),
                  title: const Text("عرض الشكاوي"),
                  onTap: () {
                    Get.back();
                    Get.to(() => ComplaintsListView());
                  },
                  tileColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              ],
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _complaintsExpanded = expanded;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: 'log_out'.tr,
            color: const Color(0xFFEF4444),
            isDestructive: true,
            onTap: () async {
              Get.back();
              Get.defaultDialog(
                title: "confirm_logout".tr,
                middleText: "logout_confirmation_msg".tr,
                textCancel: "cancel".tr,
                textConfirm: "yes".tr,
                confirmTextColor: Colors.white,
                buttonColor: const Color(0xFFEF4444),
                onConfirm: () async {
                  Get.back();
                  Get.dialog(
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF667EEA),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "logging_out".tr,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierDismissible: false,
                  );

                  await AuthApiService.logout();
                  await GetStorage().erase();
                  ApiService.token = null;
                  Get.offAll(() => const LoginView());
                },
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDestructive ? color : const Color(0xFF1E293B),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: color,
            size: 14,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}
