import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_strings.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  // Page controller for managing page views
  late PageController pageController;
  
  // Observable variables
  final currentPage = 0.obs;
  final isLastPage = false.obs;
  
  // Onboarding items data
  final List<Map<String, dynamic>> onboardingItems = [
    {
      'icon': Icons.chat_bubble_outline,
      'title': AppStrings.onboardingTitle1,
      'description': AppStrings.onboardingDesc1,
    },
    {
      'icon': Icons.security,
      'title': AppStrings.onboardingTitle2,
      'description': AppStrings.onboardingDesc2,
    },
    {
      'icon': Icons.offline_bolt,
      'title': AppStrings.onboardingTitle3,
      'description': AppStrings.onboardingDesc3,
    },
  ];
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _updatePageStatus();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  /// Handle page change
  void onPageChanged(int page) {
    currentPage.value = page;
    _updatePageStatus();
  }
  
  /// Navigate to next page
  void nextPage() {
    if (currentPage.value < onboardingItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  /// Navigate to previous page
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  /// Skip onboarding and go to auth
  void skipOnboarding() {
    _completeOnboardingProcess();
  }
  
  /// Complete onboarding process
  void completeOnboarding() {
    _completeOnboardingProcess();
  }
  
  /// Update page status (is last page check)
  void _updatePageStatus() {
    isLastPage.value = currentPage.value == onboardingItems.length - 1;
  }
  
  /// Mark onboarding as completed and navigate to login
  void _completeOnboardingProcess() async {
    try {
      // Mark onboarding as completed in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      
      // Navigate to login page
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      // Handle error if needed
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.somethingWentWrong.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
