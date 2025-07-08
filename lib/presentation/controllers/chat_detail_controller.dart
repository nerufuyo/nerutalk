import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/domain/models/chat_models.dart';

class ChatDetailController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString chatName = ''.obs;
  
  final TextEditingController messageController = TextEditingController();
  
  String? chatId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    chatId = arguments?['chatId'];
    loadChatDetails();
    loadMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> loadChatDetails() async {
    try {
      // TODO: Replace with actual API call
      chatName.value = 'John Doe'; // Mock data
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat details: $e');
    }
  }

  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for now
      messages.value = [
        Message(
          id: '1',
          chatId: chatId ?? '',
          senderId: 'user2',
          senderName: 'John Doe',
          content: 'Hey, how are you doing?',
          type: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        Message(
          id: '2',
          chatId: chatId ?? '',
          senderId: 'current_user',
          senderName: 'Me',
          content: 'I\'m doing great! How about you?',
          type: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        Message(
          id: '3',
          chatId: chatId ?? '',
          senderId: 'user2',
          senderName: 'John Doe',
          content: 'Pretty good! Working on some Flutter projects.',
          type: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ].reversed.toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    try {
      isSending.value = true;
      
      // Create new message
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId ?? '',
        senderId: 'current_user',
        senderName: 'Me',
        content: content,
        type: MessageType.text,
        createdAt: DateTime.now(),
      );

      // Add to local list first for immediate UI update
      messages.insert(0, newMessage);
      messageController.clear();
      
      // TODO: Send to backend via API
      await Future.delayed(const Duration(seconds: 1));
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
      // Remove message from list if sending failed
      messages.removeWhere((msg) => msg.content == content);
    } finally {
      isSending.value = false;
    }
  }

  void showChatInfo() {
    // TODO: Navigate to chat info page
    Get.snackbar('Info', 'Chat info feature coming soon!');
  }
}
