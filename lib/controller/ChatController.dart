import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../constants/pusher_constants.dart';
import '../services/chat_api_service.dart';

class ChatController extends GetxController {
  final int orderId;
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;

  late final PusherChannelsFlutter pusher;

  ChatController(this.orderId);

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
    initPusher();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final response = await ChatApiService.getOrderMessages(orderId);
      if (response['status'] == 1) {
        messages.value = List<Map<String, dynamic>>.from(response['data']['messages']);
      } else {
        Get.snackbar("المحادثة", response['message'] ?? "فشل في جلب الرسائل");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل المحادثة");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await ChatApiService.sendOrderMessage(orderId, text);
      if (response['status'] == 1) {
        messageController.clear();
        messages.add(response['data']['message']);
      } else {
        Get.snackbar("فشل الإرسال", response['message'] ?? "حدث خطأ");
      }
    } catch (e) {
      Get.snackbar("خطأ", "تعذر إرسال الرسالة");
    }
  }


  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: PUSHER_API_KEY,
        cluster: PUSHER_CLUSTER,
        onError: (String message, int? code, dynamic error) {
          print(" Pusher Error: $message");
        },
      );

      await pusher.subscribe(channelName: '$PUSHER_CHANNEL_PREFIX.$orderId');

      pusher.onEvent = (event) {
        if (event.channelName == '$PUSHER_CHANNEL_PREFIX.$orderId' &&
            event.eventName == PUSHER_EVENT_NAME) {
          try {
            final decoded = jsonDecode(event.data!);

            if (!messages.any((msg) => msg['id'] == decoded['id'])) {
              messages.add(decoded);
            }
          } catch (e) {
            print(" Decode error: $e");
          }
        }
      };


      await pusher.connect();
    } catch (e) {
      print(" Failed to init Pusher: $e");
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    pusher.unsubscribe(channelName: '$PUSHER_CHANNEL_PREFIX.$orderId');
    super.onClose();
  }
}
