import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_strings.dart';

/// Internationalization service for handling multiple languages
/// Provides translation functionality with fallback support
class AppTranslations extends Translations {
  // Supported locales
  static const Locale englishLocale = Locale('en', 'US');
  static const Locale indonesianLocale = Locale('id', 'ID');
  static const Locale chineseLocale = Locale('zh', 'CN');
  static const Locale japaneseLocale = Locale('ja', 'JP');
  static const Locale koreanLocale = Locale('ko', 'KR');

  // Fallback locale
  static const Locale fallbackLocale = englishLocale;

  // List of supported locales
  static const List<Locale> supportedLocales = [
    englishLocale,
    indonesianLocale,
    chineseLocale,
    japaneseLocale,
    koreanLocale,
  ];

  // Static translation maps for each language
  static Map<String, Map<String, String>> _translations = {};

  /// Initialize translations by loading all language files
  static Future<void> initialize() async {
    await _loadTranslations();
  }

  /// Load translation files from assets
  static Future<void> _loadTranslations() async {
    final languages = [
      {'code': 'en', 'file': 'assets/translations/en.json'},
      {'code': 'id', 'file': 'assets/translations/id.json'},
      {'code': 'zh_CN', 'file': 'assets/translations/cn.json'},
      {'code': 'ja_JP', 'file': 'assets/translations/jp.json'},
      {'code': 'ko_KR', 'file': 'assets/translations/ko.json'},
    ];

    for (final language in languages) {
      try {
        final String jsonString = await rootBundle.loadString(language['file']!);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _translations[language['code']!] = Map<String, String>.from(jsonMap);
      } catch (e) {
        // Handle error gracefully, log if needed
        print('Error loading translation file ${language['file']}: $e');
      }
    }
  }

  /// Get translation keys for GetX
  @override
  Map<String, Map<String, String>> get keys => _translations;

  /// Get translated string with optional parameters
  static String tr(String key, {Map<String, String>? parameters}) {
    String translation = Get.tr(key);
    
    // Replace parameters if provided
    if (parameters != null) {
      parameters.forEach((param, value) {
        translation = translation.replaceAll('{$param}', value);
      });
    }
    
    return translation;
  }

  /// Get current locale language code
  static String getCurrentLanguageCode() {
    final locale = Get.locale ?? fallbackLocale;
    return _getLanguageCodeFromLocale(locale);
  }

  /// Convert locale to language code
  static String _getLanguageCodeFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return AppStrings.englishCode;
      case 'id':
        return AppStrings.indonesianCode;
      case 'zh':
        return AppStrings.chineseCode;
      case 'ja':
        return AppStrings.japaneseCode;
      case 'ko':
        return AppStrings.koreanCode;
      default:
        return AppStrings.englishCode;
    }
  }

  /// Convert language code to locale
  static Locale getLocaleFromLanguageCode(String code) {
    switch (code) {
      case AppStrings.englishCode:
        return englishLocale;
      case AppStrings.indonesianCode:
        return indonesianLocale;
      case AppStrings.chineseCode:
        return chineseLocale;
      case AppStrings.japaneseCode:
        return japaneseLocale;
      case AppStrings.koreanCode:
        return koreanLocale;
      default:
        return fallbackLocale;
    }
  }

  /// Get language display name
  static String getLanguageDisplayName(String code) {
    switch (code) {
      case AppStrings.englishCode:
        return 'English';
      case AppStrings.indonesianCode:
        return 'Bahasa Indonesia';
      case AppStrings.chineseCode:
        return '中文';
      case AppStrings.japaneseCode:
        return '日本語';
      case AppStrings.koreanCode:
        return '한국어';
      default:
        return 'English';
    }
  }

  /// Save selected language to preferences
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.languageKey, languageCode);
  }

  /// Load saved language from preferences
  static Future<String?> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.languageKey);
  }

  /// Change app language
  static Future<void> changeLanguage(String languageCode) async {
    final locale = getLocaleFromLanguageCode(languageCode);
    await Get.updateLocale(locale);
    await saveLanguage(languageCode);
  }

  /// Get system language if supported, otherwise return fallback
  static Locale getSystemLocale() {
    final systemLocale = Get.deviceLocale;
    if (systemLocale != null && _isLocaleSupported(systemLocale)) {
      return systemLocale;
    }
    return fallbackLocale;
  }

  /// Check if locale is supported
  static bool _isLocaleSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  /// Initialize app language on startup
  static Future<void> initializeLanguage() async {
    await initialize();
    
    final savedLanguage = await getSavedLanguage();
    
    if (savedLanguage != null) {
      // Use saved language
      final locale = getLocaleFromLanguageCode(savedLanguage);
      Get.updateLocale(locale);
    } else {
      // Use system language if supported, otherwise fallback
      final systemLocale = getSystemLocale();
      Get.updateLocale(systemLocale);
      
      // Save the chosen language for next time
      final languageCode = _getLanguageCodeFromLocale(systemLocale);
      await saveLanguage(languageCode);
    }
  }

  /// Get list of available languages
  static List<Map<String, String>> getAvailableLanguages() {
    return [
      {
        'code': AppStrings.englishCode,
        'name': 'English',
        'nativeName': 'English',
      },
      {
        'code': AppStrings.indonesianCode,
        'name': 'Indonesian',
        'nativeName': 'Bahasa Indonesia',
      },
      {
        'code': AppStrings.chineseCode,
        'name': 'Chinese',
        'nativeName': '中文',
      },
      {
        'code': AppStrings.japaneseCode,
        'name': 'Japanese',
        'nativeName': '日本語',
      },
      {
        'code': AppStrings.koreanCode,
        'name': 'Korean',
        'nativeName': '한국어',
      },
    ];
  }

  /// Format relative time strings
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return tr('just_now');
        } else {
          return tr('minutes_ago', parameters: {'minutes': difference.inMinutes.toString()});
        }
      } else {
        return tr('hours_ago', parameters: {'hours': difference.inHours.toString()});
      }
    } else if (difference.inDays == 1) {
      return tr('yesterday');
    } else if (difference.inDays < 7) {
      return tr('days_ago', parameters: {'days': difference.inDays.toString()});
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return tr('weeks_ago', parameters: {'weeks': weeks.toString()});
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return tr('months_ago', parameters: {'months': months.toString()});
    } else {
      final years = (difference.inDays / 365).floor();
      return tr('years_ago', parameters: {'years': years.toString()});
    }
  }

  /// Check if current language is RTL (Right-to-Left)
  static bool isRTL() {
    final locale = Get.locale ?? fallbackLocale;
    // Add RTL language codes here if needed in the future
    // Currently none of our supported languages are RTL
    return false;
  }

  /// Get text direction based on current language
  static String getTextDirection() {
    return isRTL() ? 'rtl' : 'ltr';
  }

  /// Validate translation key exists
  static bool hasTranslation(String key) {
    final currentCode = getCurrentLanguageCode();
    final localeKey = _getLocaleKeyFromCode(currentCode);
    return _translations[localeKey]?.containsKey(key) ?? false;
  }

  /// Convert language code to locale key used in translations map
  static String _getLocaleKeyFromCode(String code) {
    switch (code) {
      case AppStrings.englishCode:
        return 'en';
      case AppStrings.indonesianCode:
        return 'id';
      case AppStrings.chineseCode:
        return 'zh_CN';
      case AppStrings.japaneseCode:
        return 'ja_JP';
      case AppStrings.koreanCode:
        return 'ko_KR';
      default:
        return 'en';
    }
  }

  /// Get number format based on locale
  static String formatNumber(num number) {
    // This can be enhanced with proper number formatting for each locale
    // For now, return standard formatting
    return number.toString();
  }

  /// Get currency format based on locale
  static String formatCurrency(double amount, {String currency = 'USD'}) {
    // This can be enhanced with proper currency formatting for each locale
    // For now, return standard formatting
    return '$currency ${amount.toStringAsFixed(2)}';
  }

  /// Get date format pattern for current locale
  static String getDateFormatPattern() {
    final code = getCurrentLanguageCode();
    switch (code) {
      case AppStrings.japaneseCode:
        return 'yyyy/MM/dd';
      case AppStrings.chineseCode:
        return 'yyyy年MM月dd日';
      case AppStrings.koreanCode:
        return 'yyyy년 MM월 dd일';
      default:
        return 'MMM dd, yyyy';
    }
  }

  /// Get time format pattern for current locale
  static String getTimeFormatPattern() {
    final code = getCurrentLanguageCode();
    switch (code) {
      case AppStrings.japaneseCode:
      case AppStrings.chineseCode:
      case AppStrings.koreanCode:
        return 'HH:mm';
      default:
        return 'h:mm a';
    }
  }
}
