import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nerutalk/core/constants/app_colors.dart';
import 'package:nerutalk/core/constants/app_strings.dart';
import 'package:nerutalk/presentation/controllers/chat_list_controller.dart';
import 'package:nerutalk/presentation/routes/app_routes.dart';
import 'package:nerutalk/presentation/widgets/common/loading_indicator.dart';

class ChatListPage extends GetView<ChatListController> {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.chats.tr),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.newChat),
            icon: const Icon(Icons.add_comment),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        if (controller.chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noChats.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.startFirstChat.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshChats,
          child: ListView.builder(
            itemCount: controller.chats.length,
            itemBuilder: (context, index) {
              final chat = controller.chats[index];
              return _buildChatItem(chat);
            },
          ),
        );
      }),
    );
  }

  Widget _buildChatItem(dynamic chat) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Text(
          chat.name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        chat.name,
        style: TextStyle(
          fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        chat.lastMessage ?? AppStrings.noMessages.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chat.lastMessageAt),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () => Get.toNamed(
        AppRoutes.chatDetail,
        arguments: {'chatId': chat.id},
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return AppStrings.now.tr;
    }
  }
}
