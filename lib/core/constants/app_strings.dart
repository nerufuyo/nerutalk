/// Global string constants for NeruTalk application
/// This class provides centralized access to all string constants
/// used throughout the application for better maintenance and consistency
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // App Information
  static const String appName = 'NeruTalk';
  static const String appDescription = 'Modern Chat Application';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String wsBaseUrl = 'ws://localhost:8000/ws';
  
  // Authentication Endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String refreshTokenEndpoint = '/refresh-token';
  static const String logoutEndpoint = '/logout';
  static const String profileEndpoint = '/profile';
  
  // Chat Endpoints
  static const String chatsEndpoint = '/chats';
  static const String messagesEndpoint = '/messages';
  static const String uploadFileEndpoint = '/files/upload';
  
  // Video Call Endpoints
  static const String videoCallsEndpoint = '/video-calls';
  static const String initiateCallEndpoint = '/video-calls/initiate';
  
  // Location Endpoints
  static const String locationEndpoint = '/location';
  static const String updateLocationEndpoint = '/location/update';
  static const String nearbyUsersEndpoint = '/location/nearby';
  
  // Push Notification Endpoints
  static const String deviceTokensEndpoint = '/push-notifications/device-tokens';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String firstTimeKey = 'first_time_user';
  static const String biometricKey = 'biometric_enabled';
  static const String notificationKey = 'notification_enabled';
  static const String locationKey = 'location_enabled';
  
  // Onboarding
  static const String skip = 'skip';
  static const String previous = 'previous';
  static const String next = 'next';
  static const String getStarted = 'get_started';
  static const String onboardingTitle1 = 'onboarding_title_1';
  static const String onboardingDesc1 = 'onboarding_desc_1';
  static const String onboardingTitle2 = 'onboarding_title_2';
  static const String onboardingDesc2 = 'onboarding_desc_2';
  static const String onboardingTitle3 = 'onboarding_title_3';
  static const String onboardingDesc3 = 'onboarding_desc_3';
  
  // Authentication
  static const String welcomeBack = 'welcome_back';
  static const String loginSubtitle = 'login_subtitle';
  static const String email = 'email';
  static const String password = 'password';
  static const String login = 'login';
  static const String forgotPassword = 'forgot_password';
  static const String or = 'or';
  static const String loginWithGoogle = 'login_with_google';
  static const String loginWithFacebook = 'login_with_facebook';
  static const String dontHaveAccount = 'dont_have_account';
  static const String signUp = 'sign_up';
  static const String signIn = 'sign_in';
  
  // Registration
  static const String createAccount = 'create_account';
  static const String signUpSubtitle = 'sign_up_subtitle';
  static const String fullName = 'full_name';
  static const String confirmPassword = 'confirm_password';
  static const String iAgreeToThe = 'i_agree_to_the';
  static const String termsAndConditions = 'terms_and_conditions';
  static const String and = 'and';
  static const String privacyPolicy = 'privacy_policy';
  static const String alreadyHaveAccount = 'already_have_account';
  
  // Media & Files
  static const String mediaGallery = 'media_gallery';
  static const String noMediaFiles = 'no_media_files';
  static const String shareFirstMedia = 'share_first_media';
  static const String all = 'all';
  static const String images = 'images';
  static const String videos = 'videos';
  static const String documents = 'documents';
  static const String stickers = 'stickers';
  static const String noStickers = 'no_stickers';
  static const String downloadStickerPacks = 'download_sticker_packs';
  static const String stickerStore = 'sticker_store';
  
  // Video Calls
  static const String noCallHistory = 'no_call_history';
  static const String startFirstCall = 'start_first_call';
  static const String newCall = 'new_call';
  static const String incoming = 'incoming';
  static const String outgoing = 'outgoing';
  static const String declined = 'declined';
  static const String missed = 'missed';
  static const String unknown = 'unknown';
  
  // Chat
  static const String noChats = 'no_chats';
  static const String startConversation = 'start_conversation';
  static const String typeMessage = 'type_message';
  static const String now = 'now';
  static const String newChat = 'new_chat';
  
  // Home
  static const String chats = 'chats';
  static const String contacts = 'contacts';
  static const String calls = 'calls';
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String logout = 'logout';
  static const String noChatsYet = 'no_chats_yet';
  static const String startFirstChat = 'start_first_chat';
  static const String startNewChat = 'start_new_chat';
  static const String unknownUser = 'unknown_user';
  static const String noMessages = 'no_messages';
  static const String contactsComingSoon = 'contacts_coming_soon';
  static const String callsComingSoon = 'calls_coming_soon';
  static const String settingsComingSoon = 'settings_coming_soon';
  static const String logoutConfirmation = 'logout_confirmation';
  static const String cancel = 'cancel';
  
  // Validation Messages
  static const String emailRequired = 'email_required';
  static const String emailInvalid = 'email_invalid';
  static const String passwordRequired = 'password_required';
  static const String passwordTooShort = 'password_too_short';
  static const String nameRequired = 'name_required';
  static const String nameTooShort = 'name_too_short';
  static const String passwordNeedsUppercase = 'password_needs_uppercase';
  static const String passwordNeedsLowercase = 'password_needs_lowercase';
  static const String passwordNeedsNumber = 'password_needs_number';
  static const String confirmPasswordRequired = 'confirm_password_required';
  static const String passwordsDoNotMatch = 'passwords_do_not_match';
  static const String mustAcceptTerms = 'must_accept_terms';
  
  // Status Messages
  static const String success = 'success';
  static const String error = 'error';
  static const String info = 'info';
  static const String warning = 'warning';
  static const String loginSuccess = 'login_success';
  static const String loginFailed = 'login_failed';
  static const String registrationSuccess = 'registration_success';
  static const String registrationFailed = 'registration_failed';
  static const String logoutSuccess = 'logout_success';
  static const String somethingWentWrong = 'something_went_wrong';
  static const String featureComingSoon = 'feature_coming_soon';
  static const String failedToLoadChats = 'failed_to_load_chats';
  
  // Database Tables
  static const String messagesTable = 'messages';
  static const String chatsTable = 'chats';
  static const String usersTable = 'users';
  static const String callHistoryTable = 'call_history';
  
  // WebSocket Events
  static const String joinChatEvent = 'join_chat';
  static const String leaveChatEvent = 'leave_chat';
  static const String typingIndicatorEvent = 'typing_indicator';
  static const String messageReadEvent = 'message_read';
  static const String callInitiatedEvent = 'call_initiated';
  static const String callAnsweredEvent = 'call_answered';
  static const String callDeclinedEvent = 'call_declined';
  static const String callEndedEvent = 'call_ended';
  static const String locationUpdateEvent = 'location_update';
  
  // File Types
  static const String imageType = 'image';
  static const String videoType = 'video';
  static const String audioType = 'audio';
  static const String documentType = 'document';
  static const String stickerType = 'sticker';
  static const String gifType = 'gif';
  
  // Message Types
  static const String textMessage = 'text';
  static const String imageMessage = 'image';
  static const String videoMessage = 'video';
  static const String audioMessage = 'audio';
  static const String documentMessage = 'document';
  static const String locationMessage = 'location';
  static const String stickerMessage = 'sticker';
  static const String gifMessage = 'gif';
  
  // Chat Types
  static const String privateChat = 'private';
  static const String groupChat = 'group';
  
  // Call Types
  static const String videoCall = 'video';
  static const String audioCall = 'audio';
  
  // Call Status
  static const String callInitiated = 'initiated';
  static const String callOngoing = 'ongoing';
  static const String callEnded = 'ended';
  static const String callMissed = 'missed';
  static const String callDeclined = 'declined';
  
  // User Status
  static const String online = 'online';
  static const String offline = 'offline';
  static const String away = 'away';
  static const String busy = 'busy';
  
  // Theme Modes
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String systemTheme = 'system';
  
  // Languages
  static const String englishCode = 'en';
  static const String indonesianCode = 'id';
  static const String chineseCode = 'cn';
  static const String japaneseCode = 'jp';
  static const String koreanCode = 'ko';
  
  // Navigation Routes
  static const String splashRoute = '/splash';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String homeRoute = '/home';
  static const String chatRoute = '/chat';
  static const String chatDetailRoute = '/chat-detail';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String callRoute = '/call';
  static const String contactsRoute = '/contacts';
  static const String searchRoute = '/search';
  static const String mediaViewerRoute = '/media-viewer';
  
  // Error Messages
  static const String networkError = 'network_error';
  static const String serverError = 'server_error';
  static const String authenticationError = 'authentication_error';
  static const String validationError = 'validation_error';
  static const String fileUploadError = 'file_upload_error';
  static const String permissionError = 'permission_error';
  static const String locationError = 'location_error';
  static const String cameraError = 'camera_error';
  static const String microphoneError = 'microphone_error';
  
  // Success Messages
  static const String loginSuccess = 'login_success';
  static const String registerSuccess = 'register_success';
  static const String profileUpdateSuccess = 'profile_update_success';
  static const String messagesentSuccess = 'message_sent_success';
  static const String fileUploadSuccess = 'file_upload_success';
  
  // Validation Messages
  static const String requiredField = 'required_field';
  static const String invalidEmail = 'invalid_email';
  static const String invalidPassword = 'invalid_password';
  static const String passwordMismatch = 'password_mismatch';
  static const String invalidUsername = 'invalid_username';
  static const String usernameTaken = 'username_taken';
  static const String emailTaken = 'email_taken';
  
  // Loading Messages
  static const String loading = 'loading';
  static const String authenticating = 'authenticating';
  static const String sendingMessage = 'sending_message';
  static const String uploadingFile = 'uploading_file';
  static const String connecting = 'connecting';
  static const String initializing = 'initializing';
  
  // Permission Messages
  static const String cameraPermission = 'camera_permission';
  static const String microphonePermission = 'microphone_permission';
  static const String locationPermission = 'location_permission';
  static const String storagePermission = 'storage_permission';
  static const String notificationPermission = 'notification_permission';
  
  // File Size Limits
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 50;
  static const int maxDocumentSizeMB = 25;
  static const int maxAudioSizeMB = 15;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
  
  // Retry Attempts
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 1000; // milliseconds
  
  // Cache Settings
  static const int cacheMaxAge = 3600; // seconds (1 hour)
  static const int maxCacheSize = 100; // MB
  
  // Animation Durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 300; // milliseconds
  static const int longAnimationDuration = 500; // milliseconds
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  // Avatar Sizes
  static const double smallAvatarSize = 32.0;
  static const double mediumAvatarSize = 48.0;
  static const double largeAvatarSize = 64.0;
  static const double extraLargeAvatarSize = 100.0;
  
  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  
  // Typography Sizes
  static const double captionFontSize = 12.0;
  static const double bodyFontSize = 14.0;
  static const double titleFontSize = 16.0;
  static const double headingFontSize = 20.0;
  static const double largeFontSize = 24.0;
  
  // Status Bar
  static const String statusBarStyle = 'status_bar_style';
  
  // Biometric Authentication
  static const String biometricReason = 'biometric_authentication_reason';
  
  // Deep Link Schemes
  static const String deepLinkScheme = 'nerutalk';
  static const String chatDeepLink = 'nerutalk://chat';
  static const String callDeepLink = 'nerutalk://call';
  
  // Firebase Topics
  static const String allUsersTopic = 'all_users';
  static const String androidTopic = 'android_users';
  static const String iosTopic = 'ios_users';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  
  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,20}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]{10,}$';
  
  // Feature Flags
  static const String videoCallFeature = 'video_call_enabled';
  static const String locationFeature = 'location_enabled';
  static const String fileShareFeature = 'file_share_enabled';
  static const String pushNotificationFeature = 'push_notification_enabled';
}
