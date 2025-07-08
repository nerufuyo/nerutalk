import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired.tr;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.emailInvalid.tr;
    }
    
    return null;
  }
  
  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired.tr;
    }
    
    if (value.length < 6) {
      return AppStrings.passwordTooShort.tr;
    }
    
    return null;
  }
  
  /// Perform login
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      final success = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (success) {
        // Navigate to home page
        Get.offAllNamed(AppRoutes.home);
        
        // Show success message
        Get.snackbar(
          AppStrings.success.tr,
          AppStrings.loginSuccess.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error message
        Get.snackbar(
          AppStrings.error.tr,
          AppStrings.loginFailed.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.somethingWentWrong.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Handle Google login
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      Get.snackbar(
        AppStrings.info.tr,
        AppStrings.featureComingSoon.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.somethingWentWrong.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Handle Facebook login
  Future<void> loginWithFacebook() async {
    try {
      isLoading.value = true;
      
      // TODO: Implement Facebook Sign-In
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      Get.snackbar(
        AppStrings.info.tr,
        AppStrings.featureComingSoon.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.somethingWentWrong.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Handle forgot password
  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }
  
  /// Navigate to sign up page
  void goToSignUp() {
    Get.toNamed(AppRoutes.register);
  }
}
