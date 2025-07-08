import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/network_service.dart';
import '../../controllers/theme_controller.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  // Observable variables
  final selectedIndex = 0.obs;
  final isLoading = false.obs;
  final chats = <Map<String, dynamic>>[].obs;
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  final NetworkService _networkService = Get.find<NetworkService>();
  final ThemeController _themeController = Get.find<ThemeController>();
  
  // Computed properties
  bool get isDarkMode => _themeController.isDarkMode.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadChats();
  }
  
  /// Handle bottom navigation tab selection
  void onTabSelected(int index) {
    selectedIndex.value = index;
    
    // Navigate to appropriate pages based on tab
    switch (index) {
      case 0: // Chats
        Get.toNamed(AppRoutes.chats);
        break;
      case 1: // Contacts
        Get.snackbar(
          AppStrings.info.tr,
          AppStrings.contactsComingSoon.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 2: // Calls
        Get.toNamed(AppRoutes.calls);
        break;
      case 3: // Settings
        Get.snackbar(
          AppStrings.info.tr,
          AppStrings.settingsComingSoon.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
    }
  }
  
  /// Toggle between light and dark theme
  void toggleTheme() {
    _themeController.toggleTheme();
  }
  
  /// Open search functionality
  void openSearch() {
    // TODO: Implement search functionality
    Get.snackbar(
      AppStrings.info.tr,
      AppStrings.featureComingSoon.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Handle menu selection
  void onMenuSelected(String value) {
    switch (value) {
      case 'profile':
        Get.toNamed(AppRoutes.profile);
        break;
      case 'notifications':
        Get.toNamed(AppRoutes.notifications);
        break;
      case 'settings':
        Get.toNamed(AppRoutes.settings);
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }
  
  /// Show logout confirmation dialog
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.logout.tr),
        content: Text(AppStrings.logoutConfirmation.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.cancel.tr),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _logout();
            },
            child: Text(
              AppStrings.logout.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Perform logout
  Future<void> _logout() async {
    try {
      isLoading.value = true;
      await _authService.logout();
      Get.offAllNamed(AppRoutes.login);
      
      Get.snackbar(
        AppStrings.success.tr,
        AppStrings.logoutSuccess.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.somethingWentWrong.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Start a new chat
  void startNewChat() {
    Get.toNamed(AppRoutes.newChat);
  }
  
  /// Open a specific chat
  void openChat(Map<String, dynamic> chat) {
    Get.toNamed(
      AppRoutes.chatDetail,
      arguments: {'chatId': chat['id']},
    );
  }
  
  /// Load chats from API or local storage
  Future<void> _loadChats() async {
    try {
      isLoading.value = true;
      
      // Check if we have internet connection
      if (_networkService.isOnline) {
        // Load from API
        await _loadChatsFromApi();
      } else {
        // Load from local storage
        await _loadChatsFromStorage();
      }
    } catch (e) {
      // Handle error
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.failedToLoadChats.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Load chats from API
  Future<void> _loadChatsFromApi() async {
    // TODO: Implement API call to load chats
    // Simulate API call for now
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    chats.value = [
      {
        'id': '1',
        'name': 'John Doe',
        'lastMessage': 'Hey there! How are you doing?',
        'time': '2:30 PM',
        'unreadCount': 2,
      },
      {
        'id': '2',
        'name': 'Jane Smith',
        'lastMessage': 'Thanks for the update!',
        'time': '1:15 PM',
        'unreadCount': 0,
      },
      {
        'id': '3',
        'name': 'Team Chat',
        'lastMessage': 'Meeting at 3 PM today',
        'time': '12:45 PM',
        'unreadCount': 5,
      },
    ];
  }
  
  /// Load chats from local storage
  Future<void> _loadChatsFromStorage() async {
    // TODO: Implement loading from local storage
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For now, just show empty state or cached data
    chats.value = [];
  }
  
  /// Refresh chats
  Future<void> refreshChats() async {
    await _loadChats();
  }
}
