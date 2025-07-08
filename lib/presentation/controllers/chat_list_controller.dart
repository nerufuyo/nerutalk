import 'package:get/get.dart';
import 'package:nerutalk/domain/models/chat_models.dart';

class ChatListController extends GetxController {
  final RxList<Chat> chats = <Chat>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for now
      chats.value = [
        Chat(
          id: '1',
          name: 'John Doe',
          type: ChatType.direct,
          participants: ['user1', 'user2'],
          lastMessage: 'Hey, how are you doing?',
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 15)),
          unreadCount: 2,
        ),
        Chat(
          id: '2',
          name: 'Flutter Developers',
          type: ChatType.group,
          participants: ['user1', 'user3', 'user4', 'user5'],
          lastMessage: 'Anyone working on a new project?',
          lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
          unreadCount: 0,
        ),
        Chat(
          id: '3',
          name: 'Alice Smith',
          type: ChatType.direct,
          participants: ['user1', 'user6'],
          lastMessage: 'Thanks for the help!',
          lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
          unreadCount: 1,
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshChats() async {
    await loadChats();
  }

  void markAsRead(String chatId) {
    final chatIndex = chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex] = chats[chatIndex].copyWith(unreadCount: 0);
      chats.refresh();
    }
  }
}
