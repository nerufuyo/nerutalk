import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Application color constants for NeruTalk
/// Provides consistent color scheme for light and dark themes
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors - Brand Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueDark = Color(0xFF1976D2);
  static const Color primaryBlueLight = Color(0xFF64B5F6);

  static const Color secondaryTeal = Color(0xFF00BCD4);
  static const Color secondaryTealDark = Color(0xFF0097A7);
  static const Color secondaryTealLight = Color(0xFF4DD0E1);

  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentGreenDark = Color(0xFF388E3C);
  static const Color accentGreenLight = Color(0xFF81C784);

  // Shortcut properties for primary usage
  static const Color primary = primaryBlue;
  static const Color secondary = secondaryTeal;
  static const Color accent = accentGreen;

  // Context-dependent getters for current theme
  static Color get surface => getSurfaceColor(Get.isDarkMode);
  static Color get border => getBorderColor(Get.isDarkMode);
  static Color get card => getCardColor(Get.isDarkMode);
  static Color get divider => getDividerColor(Get.isDarkMode);
  static Color get onSurface => getOnSurfaceColor(Get.isDarkMode);
  static Color get onBackground => getOnBackgroundColor(Get.isDarkMode);
  static Color get shimmerBase => getShimmerBaseColor(Get.isDarkMode);
  static Color get shimmerHighlight => getShimmerHighlightColor(Get.isDarkMode);
  static Color get inputFill => getInputFillColor(Get.isDarkMode);
  static Color get inputBorder => getInputBorderColor(Get.isDarkMode);

  // Common colors
  static const Color grey = Color(0xFF9E9E9E);
  static const Color background = lightBackground;
  static const Color backgroundDark = darkBackground;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightSurfaceVariant = Color(0xFFEEEEEE);
  static const Color lightOnBackground = Color(0xFF000000);
  static const Color lightOnSurface = Color(0xFF212121);
  static const Color lightOnSurfaceVariant = Color(0xFF757575);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2D2D2D);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnSurfaceVariant = Color(0xFFBDBDBD);

  // Chat Colors
  static const Color myMessageBackground = Color(0xFF2196F3);
  static const Color myMessageBackgroundDark = Color(0xFF1976D2);
  static const Color otherMessageBackground = Color(0xFFE0E0E0);
  static const Color otherMessageBackgroundDark = Color(0xFF424242);

  static const Color myMessageText = Color(0xFFFFFFFF);
  static const Color otherMessageText = Color(0xFF000000);
  static const Color otherMessageTextDark = Color(0xFFFFFFFF);

  // Status Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFF44336);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);

  // Online Status Colors
  static const Color onlineGreen = Color(0xFF4CAF50);
  static const Color awayYellow = Color(0xFFFFC107);
  static const Color busyRed = Color(0xFFF44336);
  static const Color offlineGrey = Color(0xFF9E9E9E);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Grey Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Border Colors
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color darkBorder = Color(0xFF424242);

  // Divider Colors
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color darkDivider = Color(0xFF424242);

  // Shimmer Colors
  static const Color lightShimmerBase = Color(0xFFE0E0E0);
  static const Color lightShimmerHighlight = Color(0xFFF5F5F5);
  static const Color darkShimmerBase = Color(0xFF424242);
  static const Color darkShimmerHighlight = Color(0xFF616161);

  // Shadow Colors
  static const Color lightShadow = Color(0x1F000000);
  static const Color darkShadow = Color(0x3F000000);

  // Overlay Colors
  static const Color lightOverlay = Color(0x66000000);
  static const Color darkOverlay = Color(0x80000000);

  // Input Field Colors
  static const Color lightInputFill = Color(0xFFF5F5F5);
  static const Color darkInputFill = Color(0xFF2D2D2D);
  static const Color lightInputBorder = Color(0xFFE0E0E0);
  static const Color darkInputBorder = Color(0xFF424242);
  static const Color focusedBorder = Color(0xFF2196F3);
  static const Color errorBorder = Color(0xFFF44336);

  // Button Colors
  static const Color primaryButton = Color(0xFF2196F3);
  static const Color primaryButtonDark = Color(0xFF1976D2);
  static const Color secondaryButton = Color(0xFFE0E0E0);
  static const Color secondaryButtonDark = Color(0xFF424242);
  static const Color disabledButton = Color(0xFFBDBDBD);
  static const Color disabledButtonDark = Color(0xFF616161);

  // Card Colors
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color lightCardBorder = Color(0xFFE0E0E0);
  static const Color darkCardBorder = Color(0xFF424242);

  // Notification Colors
  static const Color notificationRed = Color(0xFFF44336);
  static const Color notificationBadge = Color(0xFFF44336);

  // Call Colors
  static const Color callGreen = Color(0xFF4CAF50);
  static const Color callRed = Color(0xFFF44336);
  static const Color callYellow = Color(0xFFFFC107);

  // File Type Colors
  static const Color pdfRed = Color(0xFFF44336);
  static const Color docBlue = Color(0xFF2196F3);
  static const Color xlsGreen = Color(0xFF4CAF50);
  static const Color pptOrange = Color(0xFFFF9800);
  static const Color zipPurple = Color(0xFF9C27B0);
  static const Color imageBlue = Color(0xFF03A9F4);
  static const Color videoRed = Color(0xFFE91E63);
  static const Color audioOrange = Color(0xFFFF5722);

  // Location Colors
  static const Color locationBlue = Color(0xFF2196F3);
  static const Color geofenceGreen = Color(0xFF4CAF50);
  static const Color geofenceRed = Color(0xFFF44336);

  // Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFF4285F4);
  static const Color apple = Color(0xFF000000);
  static const Color twitter = Color(0xFF1DA1F2);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryTeal, secondaryTealDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [accentGreen, accentGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [lightBackground, lightSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Message Status Colors
  static const Color messageSent = Color(0xFF9E9E9E);
  static const Color messageDelivered = Color(0xFF2196F3);
  static const Color messageRead = Color(0xFF4CAF50);
  static const Color messageFailed = Color(0xFFF44336);

  // Typing Indicator Colors
  static const Color typingDot1 = Color(0xFF9E9E9E);
  static const Color typingDot2 = Color(0xFF757575);
  static const Color typingDot3 = Color(0xFF616161);

  // Connection Status Colors
  static const Color connected = Color(0xFF4CAF50);
  static const Color connecting = Color(0xFFFFC107);
  static const Color disconnected = Color(0xFFF44336);
  static const Color reconnecting = Color(0xFFFF9800);

  // Helper methods for theme-based colors
  static Color getBackgroundColor(bool isDark) {
    return isDark ? darkBackground : lightBackground;
  }

  static Color getSurfaceColor(bool isDark) {
    return isDark ? darkSurface : lightSurface;
  }

  static Color getOnBackgroundColor(bool isDark) {
    return isDark ? darkOnBackground : lightOnBackground;
  }

  static Color getOnSurfaceColor(bool isDark) {
    return isDark ? darkOnSurface : lightOnSurface;
  }

  static Color getBorderColor(bool isDark) {
    return isDark ? darkBorder : lightBorder;
  }

  static Color getDividerColor(bool isDark) {
    return isDark ? darkDivider : lightDivider;
  }

  static Color getCardColor(bool isDark) {
    return isDark ? darkCard : lightCard;
  }

  static Color getInputFillColor(bool isDark) {
    return isDark ? darkInputFill : lightInputFill;
  }

  static Color getInputBorderColor(bool isDark) {
    return isDark ? darkInputBorder : lightInputBorder;
  }

  static Color getMessageBackgroundColor(bool isMe, bool isDark) {
    if (isMe) {
      return isDark ? myMessageBackgroundDark : myMessageBackground;
    } else {
      return isDark ? otherMessageBackgroundDark : otherMessageBackground;
    }
  }

  static Color getMessageTextColor(bool isMe, bool isDark) {
    if (isMe) {
      return myMessageText;
    } else {
      return isDark ? otherMessageTextDark : otherMessageText;
    }
  }

  static Color getShimmerBaseColor(bool isDark) {
    return isDark ? darkShimmerBase : lightShimmerBase;
  }

  static Color getShimmerHighlightColor(bool isDark) {
    return isDark ? darkShimmerHighlight : lightShimmerHighlight;
  }
}
