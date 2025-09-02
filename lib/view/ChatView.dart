import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/ChatController.dart';
class ChatView extends StatelessWidget {
  final int orderId;
  ChatView({super.key, required this.orderId});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('محادثة الطلب'),
        backgroundColor: const Color(0xFF334EAC),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.minScrollExtent);
          }
        });

        return Column(
          children: [
            Expanded(
              child: controller.messages.isEmpty
                  ? const Center(child: Text("ابدأ المحادثة"))
                  : ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final msg = controller.messages.reversed.toList()[index];
                  final isMe = msg['sender_name'] == 'customer';

                  final DateTime dateTime = DateTime.tryParse(msg['created_at'] ?? '') ?? DateTime.now();
                  final formattedTime = DateFormat('HH:mm | dd/MM/yyyy').format(dateTime);

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFF334EAC) : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg['message'],
                            style: TextStyle(color: isMe ? Colors.white : Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            formattedTime,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                      decoration: InputDecoration(
                        hintText: "اكتب رسالتك هنا...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Obx(() {
                    return IconButton(
                      icon: controller.isLoading.value
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : const Icon(Icons.send, color: Color(0xFF334EAC)),
                      onPressed: controller.isLoading.value ? null : controller.sendMessage,
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
