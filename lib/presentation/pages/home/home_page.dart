import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName.tr),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.background,
        elevation: 0,
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: controller.openSearch,
          ),
          // Theme toggle button
          Obx(() => IconButton(
            icon: Icon(
              controller.isDarkMode.value
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: controller.toggleTheme,
          )),
          // More options
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: controller.onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 12),
                    Text(AppStrings.profile.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(width: 12),
                    Text(AppStrings.settings.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout_outlined),
                    const SizedBox(width: 12),
                    Text(AppStrings.logout.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: const [
          // Chats tab
          _ChatsTab(),
          // Contacts tab
          _ContactsTab(),
          // Calls tab
          _CallsTab(),
          // Settings tab
          _SettingsTab(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: AppStrings.chats.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contacts_outlined),
            activeIcon: const Icon(Icons.contacts),
            label: AppStrings.contacts.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.call_outlined),
            activeIcon: const Icon(Icons.call),
            label: AppStrings.calls.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: AppStrings.settings.tr,
          ),
        ],
      )),
      floatingActionButton: Obx(() => controller.selectedIndex.value == 0
          ? FloatingActionButton(
              onPressed: controller.startNewChat,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.chat_outlined,
                color: Colors.white,
              ),
            )
          : const SizedBox.shrink()),
    );
  }
}

class _ChatsTab extends GetView<HomeController> {
  const _ChatsTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.chats.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: AppColors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noChatsYet.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.startFirstChat.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: controller.startNewChat,
                icon: const Icon(Icons.add),
                label: Text(AppStrings.startNewChat.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
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
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  chat['name']?.toString().substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                chat['name']?.toString() ?? AppStrings.unknownUser.tr,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                chat['lastMessage']?.toString() ?? AppStrings.noMessages.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat['time']?.toString() ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  if (chat['unreadCount'] != null && chat['unreadCount'] > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        chat['unreadCount'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () => controller.openChat(chat),
            );
          },
        ),
      );
    });
  }
}

class _ContactsTab extends StatelessWidget {
  const _ContactsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.contacts_outlined,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.contactsComingSoon.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _CallsTab extends StatelessWidget {
  const _CallsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.call_outlined,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.callsComingSoon.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings_outlined,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.settingsComingSoon.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
