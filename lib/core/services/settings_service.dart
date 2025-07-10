import 'package:get/get.dart';
import 'network_service.dart';
import 'auth_service.dart';
import '../../domain/models/settings_models.dart';

/// Settings service for managing app settings, privacy, security, and account settings
class SettingsService extends GetxService {
  final NetworkService _networkService = Get.find<NetworkService>();
  final AuthService _authService = Get.find<AuthService>();

  // Reactive settings
  final Rx<AppSettings?> _appSettings = Rx<AppSettings?>(null);
  final Rx<PrivacySettings?> _privacySettings = Rx<PrivacySettings?>(null);
  final Rx<SecuritySettings?> _securitySettings = Rx<SecuritySettings?>(null);
  final Rx<AccountSettings?> _accountSettings = Rx<AccountSettings?>(null);

  // Loading states
  final RxBool _isLoadingAppSettings = false.obs;
  final RxBool _isLoadingPrivacySettings = false.obs;
  final RxBool _isLoadingSecuritySettings = false.obs;
  final RxBool _isLoadingAccountSettings = false.obs;

  // Getters
  AppSettings? get appSettings => _appSettings.value;
  PrivacySettings? get privacySettings => _privacySettings.value;
  SecuritySettings? get securitySettings => _securitySettings.value;
  AccountSettings? get accountSettings => _accountSettings.value;

  bool get isLoadingAppSettings => _isLoadingAppSettings.value;
  bool get isLoadingPrivacySettings => _isLoadingPrivacySettings.value;
  bool get isLoadingSecuritySettings => _isLoadingSecuritySettings.value;
  bool get isLoadingAccountSettings => _isLoadingAccountSettings.value;

  @override
  void onInit() {
    super.onInit();
    _initializeSettings();
  }

  /// Initialize settings when service starts
  void _initializeSettings() {
    if (_authService.isLoggedIn) {
      loadAllSettings();
    }
  }

  /// Load all user settings
  Future<void> loadAllSettings() async {
    await Future.wait([
      loadAppSettings(),
      loadPrivacySettings(),
      loadSecuritySettings(),
      loadAccountSettings(),
    ]);
  }

  /// Load app settings
  Future<AppSettings?> loadAppSettings() async {
    try {
      _isLoadingAppSettings.value = true;

      final response = await _networkService.get('/settings/app');

      if (response.isSuccess && response.data != null) {
        final settings = AppSettings.fromJson(response.data!);
        _appSettings.value = settings;
        return settings;
      }

      // Return default settings if none found
      final defaultSettings = AppSettings(
        userId: _authService.currentUser?.id ?? '',
      );
      _appSettings.value = defaultSettings;
      return defaultSettings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load app settings: ${e.toString()}');
      return null;
    } finally {
      _isLoadingAppSettings.value = false;
    }
  }

  /// Update app settings
  Future<bool> updateAppSettings(AppSettings settings) async {
    try {
      final response = await _networkService.put(
        '/settings/app',
        data: settings.toJson(),
      );

      if (response.isSuccess) {
        _appSettings.value = settings.copyWith(updatedAt: DateTime.now());
        Get.snackbar('Success', 'App settings updated successfully');
        return true;
      }

      Get.snackbar(
        'Error',
        response.message ?? 'Failed to update app settings',
      );
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update app settings: ${e.toString()}');
      return false;
    }
  }

  /// Load privacy settings
  Future<PrivacySettings?> loadPrivacySettings() async {
    try {
      _isLoadingPrivacySettings.value = true;

      final response = await _networkService.get('/settings/privacy');

      if (response.isSuccess && response.data != null) {
        final settings = PrivacySettings.fromJson(response.data!);
        _privacySettings.value = settings;
        return settings;
      }

      // Return default settings if none found
      final defaultSettings = PrivacySettings(
        userId: _authService.currentUser?.id ?? '',
      );
      _privacySettings.value = defaultSettings;
      return defaultSettings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load privacy settings: ${e.toString()}');
      return null;
    } finally {
      _isLoadingPrivacySettings.value = false;
    }
  }

  /// Update privacy settings
  Future<bool> updatePrivacySettings(PrivacySettings settings) async {
    try {
      final response = await _networkService.put(
        '/settings/privacy',
        data: settings.toJson(),
      );

      if (response.isSuccess) {
        _privacySettings.value = settings.copyWith(updatedAt: DateTime.now());
        Get.snackbar('Success', 'Privacy settings updated successfully');
        return true;
      }

      Get.snackbar(
        'Error',
        response.message ?? 'Failed to update privacy settings',
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update privacy settings: ${e.toString()}',
      );
      return false;
    }
  }

  /// Load security settings
  Future<SecuritySettings?> loadSecuritySettings() async {
    try {
      _isLoadingSecuritySettings.value = true;

      final response = await _networkService.get('/settings/security');

      if (response.isSuccess && response.data != null) {
        final settings = SecuritySettings.fromJson(response.data!);
        _securitySettings.value = settings;
        return settings;
      }

      // Return default settings if none found
      final defaultSettings = SecuritySettings(
        userId: _authService.currentUser?.id ?? '',
      );
      _securitySettings.value = defaultSettings;
      return defaultSettings;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load security settings: ${e.toString()}',
      );
      return null;
    } finally {
      _isLoadingSecuritySettings.value = false;
    }
  }

  /// Update security settings
  Future<bool> updateSecuritySettings(SecuritySettings settings) async {
    try {
      final response = await _networkService.put(
        '/settings/security',
        data: settings.toJson(),
      );

      if (response.isSuccess) {
        _securitySettings.value = settings.copyWith(updatedAt: DateTime.now());
        Get.snackbar('Success', 'Security settings updated successfully');
        return true;
      }

      Get.snackbar(
        'Error',
        response.message ?? 'Failed to update security settings',
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update security settings: ${e.toString()}',
      );
      return false;
    }
  }

  /// Load account settings
  Future<AccountSettings?> loadAccountSettings() async {
    try {
      _isLoadingAccountSettings.value = true;

      final response = await _networkService.get('/settings/account');

      if (response.isSuccess && response.data != null) {
        final settings = AccountSettings.fromJson(response.data!);
        _accountSettings.value = settings;
        return settings;
      }

      // Return default settings if none found
      final defaultSettings = AccountSettings(
        userId: _authService.currentUser?.id ?? '',
      );
      _accountSettings.value = defaultSettings;
      return defaultSettings;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load account settings: ${e.toString()}');
      return null;
    } finally {
      _isLoadingAccountSettings.value = false;
    }
  }

  /// Update account settings
  Future<bool> updateAccountSettings(AccountSettings settings) async {
    try {
      final response = await _networkService.put(
        '/settings/account',
        data: settings.toJson(),
      );

      if (response.isSuccess) {
        _accountSettings.value = settings.copyWith(updatedAt: DateTime.now());
        Get.snackbar('Success', 'Account settings updated successfully');
        return true;
      }

      Get.snackbar(
        'Error',
        response.message ?? 'Failed to update account settings',
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update account settings: ${e.toString()}',
      );
      return false;
    }
  }

  /// Change app language
  Future<bool> changeLanguage(String languageCode) async {
    try {
      if (_appSettings.value != null) {
        final updatedSettings = _appSettings.value!.copyWith(
          language: languageCode,
        );
        return await updateAppSettings(updatedSettings);
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to change language: ${e.toString()}');
      return false;
    }
  }

  /// Change app theme
  Future<bool> changeTheme(String theme) async {
    try {
      if (_appSettings.value != null) {
        final updatedSettings = _appSettings.value!.copyWith(theme: theme);
        return await updateAppSettings(updatedSettings);
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to change theme: ${e.toString()}');
      return false;
    }
  }

  /// Block user
  Future<bool> blockUser(String userId) async {
    try {
      final response = await _networkService.post(
        '/settings/privacy/block',
        data: {'user_id': userId},
      );

      if (response.isSuccess && _privacySettings.value != null) {
        final updatedBlockedUsers = List<String>.from(
          _privacySettings.value!.blockedUsers,
        )..add(userId);
        final updatedSettings = _privacySettings.value!.copyWith(
          blockedUsers: updatedBlockedUsers,
          updatedAt: DateTime.now(),
        );
        _privacySettings.value = updatedSettings;
        Get.snackbar('Success', 'User blocked successfully');
        return true;
      }

      Get.snackbar('Error', response.message ?? 'Failed to block user');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to block user: ${e.toString()}');
      return false;
    }
  }

  /// Unblock user
  Future<bool> unblockUser(String userId) async {
    try {
      final response = await _networkService.post(
        '/settings/privacy/unblock',
        data: {'user_id': userId},
      );

      if (response.isSuccess && _privacySettings.value != null) {
        final updatedBlockedUsers = List<String>.from(
          _privacySettings.value!.blockedUsers,
        )..remove(userId);
        final updatedSettings = _privacySettings.value!.copyWith(
          blockedUsers: updatedBlockedUsers,
          updatedAt: DateTime.now(),
        );
        _privacySettings.value = updatedSettings;
        Get.snackbar('Success', 'User unblocked successfully');
        return true;
      }

      Get.snackbar('Error', response.message ?? 'Failed to unblock user');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to unblock user: ${e.toString()}');
      return false;
    }
  }

  /// Enable two-factor authentication
  Future<bool> enableTwoFactorAuth() async {
    try {
      final response = await _networkService.post(
        '/settings/security/2fa/enable',
      );

      if (response.isSuccess && _securitySettings.value != null) {
        final updatedSettings = _securitySettings.value!.copyWith(
          twoFactorAuth: true,
          updatedAt: DateTime.now(),
        );
        _securitySettings.value = updatedSettings;
        Get.snackbar('Success', 'Two-factor authentication enabled');
        return true;
      }

      Get.snackbar(
        'Error',
        response.message ?? 'Failed to enable two-factor authentication',
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to enable two-factor authentication: ${e.toString()}',
      );
      return false;
    }
  }

  /// Disable two-factor authentication
  Future<bool> disableTwoFactorAuth() async {
    try {
      final response = await _networkService.post(
        '/settings/security/2fa/disable',
      );

      if (response.isSuccess && _securitySettings.value != null) {
        final updatedSettings = _securitySettings.value!.copyWith(
          twoFactorAuth: false,
          updatedAt: DateTime.now(),
        );
        _securitySettings.value = updatedSettings;
        Get.snackbar('Success', 'Two-factor authentication disabled');
        return true;
      }

      Get.snackbar(
        'Error',
        response.message ?? 'Failed to disable two-factor authentication',
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to disable two-factor authentication: ${e.toString()}',
      );
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _networkService.post(
        '/settings/security/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.isSuccess && _securitySettings.value != null) {
        final updatedSettings = _securitySettings.value!.copyWith(
          lastPasswordChange: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _securitySettings.value = updatedSettings;
        Get.snackbar('Success', 'Password changed successfully');
        return true;
      }

      Get.snackbar('Error', response.message ?? 'Failed to change password');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password: ${e.toString()}');
      return false;
    }
  }

  /// Deactivate account
  Future<bool> deactivateAccount() async {
    try {
      final response = await _networkService.post(
        '/settings/account/deactivate',
      );

      if (response.isSuccess) {
        Get.snackbar('Success', 'Account deactivated successfully');
        await _authService.logout();
        return true;
      }

      Get.snackbar('Error', response.message ?? 'Failed to deactivate account');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to deactivate account: ${e.toString()}');
      return false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      final response = await _networkService.delete('/settings/account');

      if (response.isSuccess) {
        Get.snackbar('Success', 'Account deleted successfully');
        await _authService.logout();
        return true;
      }

      Get.snackbar('Error', response.message ?? 'Failed to delete account');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: ${e.toString()}');
      return false;
    }
  }

  /// Export user data
  Future<bool> exportUserData() async {
    try {
      final response = await _networkService.post('/settings/account/export');

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Data export initiated. You will receive an email when ready.',
        );
        return true;
      }

      Get.snackbar('Error', response.message ?? 'Failed to export data');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to export data: ${e.toString()}');
      return false;
    }
  }

  /// Get security logs
  Future<List<SecurityLog>> getSecurityLogs() async {
    try {
      final response = await _networkService.get('/settings/security/logs');

      if (response.isSuccess && response.data != null) {
        final logs = (response.data!['logs'] as List)
            .map((log) => SecurityLog.fromJson(log))
            .toList();
        return logs;
      }

      return [];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load security logs: ${e.toString()}');
      return [];
    }
  }

  /// Clear settings cache
  void clearCache() {
    _appSettings.value = null;
    _privacySettings.value = null;
    _securitySettings.value = null;
    _accountSettings.value = null;
  }
}
