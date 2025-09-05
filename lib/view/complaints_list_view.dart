import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/complaint_controller.dart';
import 'complaint_detail_view.dart';

class ComplaintsListView extends StatelessWidget {
  final controller = Get.put(ComplaintController());

  ComplaintsListView({super.key}) {
    controller.fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "الشكاوي",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF334EAC)));
        }
        if (controller.complaints.isEmpty) {
          return const Center(
            child: Text("لا توجد شكاوي بعد.", style: TextStyle(fontSize: 16, color: Colors.black54)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: controller.complaints.length,
          itemBuilder: (context, index) {
            final complaint = controller.complaints[index];
            return ComplaintTile(complaint);
          },
        );
      }),
    );
  }
}

class ComplaintTile extends StatelessWidget {
  final Map<String, dynamic> complaint;
  const ComplaintTile(this.complaint, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isClosed = complaint['status_label'] == "منتهية"||complaint['status_label'] == "Resolved";
    final bool hasReply = (complaint['admin_reply'] != null && complaint['admin_reply'] != "");

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF8FAFC)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(() => ComplaintDetailView(id: complaint['id']));
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.report_problem_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint['subject'] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          complaint['status_label'] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Icon(
                        isClosed
                            ? Icons.check_circle
                            : Icons.info_outline,
                        color: isClosed ? Colors.green : Colors.orange,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        hasReply ? Icons.reply_all_rounded : Icons.not_interested_rounded,
                        color: hasReply ? Colors.blue : Colors.grey,
                        size: 26,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
