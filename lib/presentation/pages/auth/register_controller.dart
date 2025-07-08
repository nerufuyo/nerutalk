import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../routes/app_routes.dart';

class RegisterController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final acceptTerms = false.obs;
  
  // Services
  final AuthService _authService = Get.find<AuthService>();
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }
  
  /// Toggle accept terms checkbox
  void toggleAcceptTerms(bool? value) {
    acceptTerms.value = value ?? false;
  }
  
  /// Validate full name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nameRequired.tr;
    }
    
    if (value.trim().length < 2) {
      return AppStrings.nameTooShort.tr;
    }
    
    return null;
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
    
    if (value.length < 8) {
      return AppStrings.passwordTooShort.tr;
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppStrings.passwordNeedsUppercase.tr;
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppStrings.passwordNeedsLowercase.tr;
    }
    
    // Check for at least one number
    if (!RegExp(r'\d').hasMatch(value)) {
      return AppStrings.passwordNeedsNumber.tr;
    }
    
    return null;
  }
  
  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired.tr;
    }
    
    if (value != passwordController.text) {
      return AppStrings.passwordsDoNotMatch.tr;
    }
    
    return null;
  }
  
  /// Perform registration
  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    if (!acceptTerms.value) {
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.mustAcceptTerms.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    try {
      final success = await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (success) {
        // Navigate to home page
        Get.offAllNamed(AppRoutes.home);
        
        // Show success message
        Get.snackbar(
          AppStrings.success.tr,
          AppStrings.registrationSuccess.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error message
        Get.snackbar(
          AppStrings.error.tr,
          AppStrings.registrationFailed.tr,
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
  
  /// Navigate to login page
  void goToLogin() {
    Get.back();
  }
}
