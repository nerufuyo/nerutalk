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
          type: ChatType.private,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          participants: [
            ChatParticipant(
              id: 'p1',
              chatId: '1',
              userId: 'user1',
              displayName: 'Current User',
              role: ParticipantRole.member,
              joinedAt: DateTime.now().subtract(const Duration(days: 7)),
              isOnline: true,
            ),
            ChatParticipant(
              id: 'p2',
              chatId: '1',
              userId: 'user2',
              displayName: 'John Doe',
              role: ParticipantRole.member,
              joinedAt: DateTime.now().subtract(const Duration(days: 7)),
              isOnline: false,
            ),
          ],
          lastMessage: Message(
            id: 'm1',
            chatId: '1',
            senderId: 'user2',
            content: 'Hey, how are you doing?',
            type: MessageType.text,
            createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
            updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
          unreadCount: 2,
        ),
        Chat(
          id: '2',
          name: 'Flutter Developers',
          type: ChatType.group,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          participants: [
            ChatParticipant(
              id: 'p3',
              chatId: '2',
              userId: 'user1',
              displayName: 'Current User',
              role: ParticipantRole.admin,
              joinedAt: DateTime.now().subtract(const Duration(days: 10)),
              isOnline: true,
            ),
            ChatParticipant(
              id: 'p4',
              chatId: '2',
              userId: 'user3',
              displayName: 'Alice',
              role: ParticipantRole.member,
              joinedAt: DateTime.now().subtract(const Duration(days: 9)),
              isOnline: false,
            ),
          ],
          lastMessage: Message(
            id: 'm2',
            chatId: '2',
            senderId: 'user3',
            content: 'Anyone working on a new project?',
            type: MessageType.text,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          unreadCount: 0,
        ),
        Chat(
          id: '3',
          name: 'Alice Smith',
          type: ChatType.private,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          participants: [
            ChatParticipant(
              id: 'p5',
              chatId: '3',
              userId: 'user1',
              displayName: 'Current User',
              role: ParticipantRole.member,
              joinedAt: DateTime.now().subtract(const Duration(days: 5)),
              isOnline: true,
            ),
            ChatParticipant(
              id: 'p6',
              chatId: '3',
              userId: 'user6',
              displayName: 'Alice Smith',
              role: ParticipantRole.member,
              joinedAt: DateTime.now().subtract(const Duration(days: 5)),
              isOnline: false,
            ),
          ],
          lastMessage: Message(
            id: 'm3',
            chatId: '3',
            senderId: 'user6',
            content: 'Thanks for the help!',
            type: MessageType.text,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
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
