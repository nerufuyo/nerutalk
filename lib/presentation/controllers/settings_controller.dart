import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/settings_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/translation_service.dart';
import '../../domain/models/settings_models.dart';

/// Settings controller for managing app settings UI and state
class SettingsController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();
  final AuthService _authService = Get.find<AuthService>();
  final TranslationService _translationService = Get.find<TranslationService>();

  // Reactive variables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // App settings reactive properties
  final RxString selectedLanguage = 'en'.obs;
  final RxString selectedTheme = 'system'.obs;
  final RxString selectedFontSize = 'medium'.obs;
  final RxBool enableAnimations = true.obs;
  final RxBool enableSounds = true.obs;
  final RxBool enableVibration = true.obs;
  final RxBool enableNotifications = true.obs;
  final RxBool enableAutoDownload = true.obs;
  final RxString downloadQuality = 'medium'.obs;
  final RxBool enableLocationServices = false.obs;
  final RxBool enableBiometric = false.obs;
  final RxString dataUsageMode = 'unlimited'.obs;

  // Privacy settings reactive properties
  final RxBool showLastSeen = true.obs;
  final RxBool showOnlineStatus = true.obs;
  final RxBool showProfilePhoto = true.obs;
  final RxBool showAbout = true.obs;
  final RxBool showPhoneNumber = false.obs;
  final RxBool allowGroupInvites = true.obs;
  final RxBool allowContactsToAddMe = true.obs;
  final RxBool allowStrangersToAddMe = false.obs;
  final RxString whoCanSeeMyStory = 'contacts'.obs;
  final RxString whoCanCallMe = 'contacts'.obs;
  final RxString whoCanAddMeToGroups = 'contacts'.obs;
  final RxBool readReceipts = true.obs;
  final RxBool typingIndicators = true.obs;
  final RxList<String> blockedUsers = <String>[].obs;

  // Security settings reactive properties
  final RxBool twoFactorAuth = false.obs;
  final RxBool biometricAuth = false.obs;
  final RxBool screenLock = false.obs;
  final RxInt lockTimeout = 30.obs;
  final RxBool incognitoKeyboard = false.obs;
  final RxBool showSecurityNotifications = true.obs;
  final RxBool requireAuthForSensitiveActions = true.obs;
  final RxList<String> trustedDevices = <String>[].obs;
  final RxList<SecurityLog> securityLogs = <SecurityLog>[].obs;

  // Account settings reactive properties
  final RxBool isActive = true.obs;
  final RxBool emailVerified = false.obs;
  final RxBool phoneVerified = false.obs;
  final RxString accountType = 'free'.obs;
  final RxString subscriptionStatus = 'active'.obs;
  final RxBool allowDataCollection = false.obs;
  final RxBool allowAnalytics = false.obs;
  final RxBool allowMarketing = false.obs;

  // Language options
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'ko', 'name': '한국어'},
    {'code': 'zh', 'name': '中文'},
  ];

  // Theme options
  final List<Map<String, String>> themes = [
    {'value': 'light', 'name': 'Light'},
    {'value': 'dark', 'name': 'Dark'},
    {'value': 'system', 'name': 'System'},
  ];

  // Font size options
  final List<Map<String, String>> fontSizes = [
    {'value': 'small', 'name': 'Small'},
    {'value': 'medium', 'name': 'Medium'},
    {'value': 'large', 'name': 'Large'},
  ];

  // Download quality options
  final List<Map<String, String>> downloadQualities = [
    {'value': 'low', 'name': 'Low'},
    {'value': 'medium', 'name': 'Medium'},
    {'value': 'high', 'name': 'High'},
  ];

  // Data usage mode options
  final List<Map<String, String>> dataUsageModes = [
    {'value': 'unlimited', 'name': 'Unlimited'},
    {'value': 'low', 'name': 'Low Data Usage'},
    {'value': 'extreme', 'name': 'Extreme Data Saver'},
  ];

  // Privacy options
  final List<Map<String, String>> privacyOptions = [
    {'value': 'everyone', 'name': 'Everyone'},
    {'value': 'contacts', 'name': 'My Contacts'},
    {'value': 'nobody', 'name': 'Nobody'},
  ];

  // Lock timeout options (in minutes)
  final List<Map<String, dynamic>> lockTimeouts = [
    {'value': 1, 'name': '1 minute'},
    {'value': 5, 'name': '5 minutes'},
    {'value': 10, 'name': '10 minutes'},
    {'value': 30, 'name': '30 minutes'},
    {'value': 60, 'name': '1 hour'},
    {'value': 0, 'name': 'Never'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadAllSettings();
  }

  /// Load all settings
  Future<void> loadAllSettings() async {
    try {
      isLoading.value = true;
      error.value = '';

      await _settingsService.loadAllSettings();
      _updateLocalSettings();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load settings: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update local reactive variables from service
  void _updateLocalSettings() {
    // App settings
    final appSettings = _settingsService.appSettings;
    if (appSettings != null) {
      selectedLanguage.value = appSettings.language;
      selectedTheme.value = appSettings.theme;
      selectedFontSize.value = appSettings.fontSize;
      enableAnimations.value = appSettings.enableAnimations;
      enableSounds.value = appSettings.enableSounds;
      enableVibration.value = appSettings.enableVibration;
      enableNotifications.value = appSettings.enableNotifications;
      enableAutoDownload.value = appSettings.enableAutoDownload;
      downloadQuality.value = appSettings.downloadQuality;
      enableLocationServices.value = appSettings.enableLocationServices;
      enableBiometric.value = appSettings.enableBiometric;
      dataUsageMode.value = appSettings.dataUsageMode;
    }

    // Privacy settings
    final privacySettings = _settingsService.privacySettings;
    if (privacySettings != null) {
      showLastSeen.value = privacySettings.showLastSeen;
      showOnlineStatus.value = privacySettings.showOnlineStatus;
      showProfilePhoto.value = privacySettings.showProfilePhoto;
      showAbout.value = privacySettings.showAbout;
      showPhoneNumber.value = privacySettings.showPhoneNumber;
      allowGroupInvites.value = privacySettings.allowGroupInvites;
      allowContactsToAddMe.value = privacySettings.allowContactsToAddMe;
      allowStrangersToAddMe.value = privacySettings.allowStrangersToAddMe;
      whoCanSeeMyStory.value = privacySettings.whoCanSeeMyStory;
      whoCanCallMe.value = privacySettings.whoCanCallMe;
      whoCanAddMeToGroups.value = privacySettings.whoCanAddMeToGroups;
      readReceipts.value = privacySettings.readReceipts;
      typingIndicators.value = privacySettings.typingIndicators;
      blockedUsers.value = privacySettings.blockedUsers;
    }

    // Security settings
    final securitySettings = _settingsService.securitySettings;
    if (securitySettings != null) {
      twoFactorAuth.value = securitySettings.twoFactorAuth;
      biometricAuth.value = securitySettings.biometricAuth;
      screenLock.value = securitySettings.screenLock;
      lockTimeout.value = securitySettings.lockTimeout;
      incognitoKeyboard.value = securitySettings.incognitoKeyboard;
      showSecurityNotifications.value =
          securitySettings.showSecurityNotifications;
      requireAuthForSensitiveActions.value =
          securitySettings.requireAuthForSensitiveActions;
      trustedDevices.value = securitySettings.trustedDevices;
      securityLogs.value = securitySettings.securityLogs;
    }

    // Account settings
    final accountSettings = _settingsService.accountSettings;
    if (accountSettings != null) {
      isActive.value = accountSettings.isActive;
      emailVerified.value = accountSettings.emailVerified;
      phoneVerified.value = accountSettings.phoneVerified;
      accountType.value = accountSettings.accountType;
      subscriptionStatus.value = accountSettings.subscriptionStatus;
      allowDataCollection.value = accountSettings.allowDataCollection;
      allowAnalytics.value = accountSettings.allowAnalytics;
      allowMarketing.value = accountSettings.allowMarketing;
    }
  }

  /// Change language
  Future<void> changeLanguage(String languageCode) async {
    try {
      final success = await _settingsService.changeLanguage(languageCode);
      if (success) {
        selectedLanguage.value = languageCode;
        await _translationService.changeLanguage(languageCode);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to change language: ${e.toString()}');
    }
  }

  /// Change theme
  Future<void> changeTheme(String theme) async {
    try {
      final success = await _settingsService.changeTheme(theme);
      if (success) {
        selectedTheme.value = theme;
        // Apply theme change to app
        Get.changeThemeMode(_getThemeMode(theme));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to change theme: ${e.toString()}');
    }
  }

  /// Get theme mode from string
  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Update app settings
  Future<void> updateAppSettings() async {
    try {
      final currentSettings = _settingsService.appSettings;
      if (currentSettings != null) {
        final updatedSettings = currentSettings.copyWith(
          language: selectedLanguage.value,
          theme: selectedTheme.value,
          fontSize: selectedFontSize.value,
          enableAnimations: enableAnimations.value,
          enableSounds: enableSounds.value,
          enableVibration: enableVibration.value,
          enableNotifications: enableNotifications.value,
          enableAutoDownload: enableAutoDownload.value,
          downloadQuality: downloadQuality.value,
          enableLocationServices: enableLocationServices.value,
          enableBiometric: enableBiometric.value,
          dataUsageMode: dataUsageMode.value,
        );
        await _settingsService.updateAppSettings(updatedSettings);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update app settings: ${e.toString()}');
    }
  }

  /// Update privacy settings
  Future<void> updatePrivacySettings() async {
    try {
      final currentSettings = _settingsService.privacySettings;
      if (currentSettings != null) {
        final updatedSettings = currentSettings.copyWith(
          showLastSeen: showLastSeen.value,
          showOnlineStatus: showOnlineStatus.value,
          showProfilePhoto: showProfilePhoto.value,
          showAbout: showAbout.value,
          showPhoneNumber: showPhoneNumber.value,
          allowGroupInvites: allowGroupInvites.value,
          allowContactsToAddMe: allowContactsToAddMe.value,
          allowStrangersToAddMe: allowStrangersToAddMe.value,
          whoCanSeeMyStory: whoCanSeeMyStory.value,
          whoCanCallMe: whoCanCallMe.value,
          whoCanAddMeToGroups: whoCanAddMeToGroups.value,
          readReceipts: readReceipts.value,
          typingIndicators: typingIndicators.value,
          blockedUsers: blockedUsers.toList(),
        );
        await _settingsService.updatePrivacySettings(updatedSettings);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update privacy settings: ${e.toString()}',
      );
    }
  }

  /// Update security settings
  Future<void> updateSecuritySettings() async {
    try {
      final currentSettings = _settingsService.securitySettings;
      if (currentSettings != null) {
        final updatedSettings = currentSettings.copyWith(
          twoFactorAuth: twoFactorAuth.value,
          biometricAuth: biometricAuth.value,
          screenLock: screenLock.value,
          lockTimeout: lockTimeout.value,
          incognitoKeyboard: incognitoKeyboard.value,
          showSecurityNotifications: showSecurityNotifications.value,
          requireAuthForSensitiveActions: requireAuthForSensitiveActions.value,
          trustedDevices: trustedDevices.toList(),
        );
        await _settingsService.updateSecuritySettings(updatedSettings);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update security settings: ${e.toString()}',
      );
    }
  }

  /// Block user
  Future<void> blockUser(String userId) async {
    try {
      final success = await _settingsService.blockUser(userId);
      if (success && !blockedUsers.contains(userId)) {
        blockedUsers.add(userId);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to block user: ${e.toString()}');
    }
  }

  /// Unblock user
  Future<void> unblockUser(String userId) async {
    try {
      final success = await _settingsService.unblockUser(userId);
      if (success) {
        blockedUsers.remove(userId);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to unblock user: ${e.toString()}');
    }
  }

  /// Toggle two-factor authentication
  Future<void> toggleTwoFactorAuth() async {
    try {
      if (twoFactorAuth.value) {
        final success = await _settingsService.disableTwoFactorAuth();
        if (success) {
          twoFactorAuth.value = false;
        }
      } else {
        final success = await _settingsService.enableTwoFactorAuth();
        if (success) {
          twoFactorAuth.value = true;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to toggle two-factor authentication: ${e.toString()}',
      );
    }
  }

  /// Change password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _settingsService.changePassword(currentPassword, newPassword);
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password: ${e.toString()}');
    }
  }

  /// Load security logs
  Future<void> loadSecurityLogs() async {
    try {
      final logs = await _settingsService.getSecurityLogs();
      securityLogs.value = logs;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load security logs: ${e.toString()}');
    }
  }

  /// Deactivate account
  Future<void> deactivateAccount() async {
    try {
      await _settingsService.deactivateAccount();
    } catch (e) {
      Get.snackbar('Error', 'Failed to deactivate account: ${e.toString()}');
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await _settingsService.deleteAccount();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: ${e.toString()}');
    }
  }

  /// Export user data
  Future<void> exportUserData() async {
    try {
      await _settingsService.exportUserData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to export data: ${e.toString()}');
    }
  }

  /// Get language name by code
  String getLanguageName(String code) {
    final language = languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'name': 'English'},
    );
    return language['name']!;
  }

  /// Get theme name by value
  String getThemeName(String value) {
    final theme = themes.firstWhere(
      (theme) => theme['value'] == value,
      orElse: () => {'name': 'System'},
    );
    return theme['name']!;
  }

  /// Get font size name by value
  String getFontSizeName(String value) {
    final fontSize = fontSizes.firstWhere(
      (size) => size['value'] == value,
      orElse: () => {'name': 'Medium'},
    );
    return fontSize['name']!;
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _authService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: ${e.toString()}');
    }
  }
}
