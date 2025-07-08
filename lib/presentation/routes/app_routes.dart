/// Application route constants
/// Centralized route definitions for navigation throughout the app
abstract class AppRoutes {
  // Authentication Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String resetPassword = '/reset-password';

  // Main App Routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Chat Routes
  static const String chats = '/chats';
  static const String chatDetail = '/chat-detail';
  static const String newChat = '/new-chat';
  static const String groupChat = '/group-chat';
  static const String createGroup = '/create-group';
  static const String groupInfo = '/group-info';
  static const String addParticipants = '/add-participants';

  // Call Routes
  static const String calls = '/calls';
  static const String videoCall = '/video-call';
  static const String audioCall = '/audio-call';
  static const String incomingCall = '/incoming-call';
  static const String callHistory = '/call-history';

  // Contact Routes
  static const String contacts = '/contacts';
  static const String addContact = '/add-contact';
  static const String contactInfo = '/contact-info';
  static const String inviteContacts = '/invite-contacts';
  static const String blockedContacts = '/blocked-contacts';

  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String profilePhoto = '/profile-photo';
  static const String profileSettings = '/profile-settings';

  // Settings Routes
  static const String settings = '/settings';
  static const String privacy = '/privacy';
  static const String security = '/security';
  static const String notifications = '/notifications';
  static const String dataUsage = '/data-usage';
  static const String storage = '/storage';
  static const String language = '/language';
  static const String theme = '/theme';
  static const String help = '/help';
  static const String about = '/about';
  static const String feedback = '/feedback';

  // Media Routes
  static const String mediaViewer = '/media-viewer';
  static const String imageViewer = '/image-viewer';
  static const String videoPlayer = '/video-player';
  static const String audioPlayer = '/audio-player';
  static const String documentViewer = '/document-viewer';
  static const String gallery = '/gallery';
  static const String camera = '/camera';

  // Search Routes
  static const String search = '/search';
  static const String searchMessages = '/search-messages';
  static const String searchContacts = '/search-contacts';

  // Location Routes
  static const String location = '/location';
  static const String shareLocation = '/share-location';
  static const String nearbyUsers = '/nearby-users';
  static const String locationHistory = '/location-history';
  static const String geofencing = '/geofencing';

  // Backup Routes
  static const String backup = '/backup';
  static const String restore = '/restore';
  static const String exportData = '/export-data';
  static const String importData = '/import-data';

  // Error Routes
  static const String error = '/error';
  static const String notFound = '/not-found';
  static const String noInternet = '/no-internet';
  static const String maintenance = '/maintenance';

  // Utility Routes
  static const String webView = '/web-view';
  static const String qrScanner = '/qr-scanner';
  static const String qrGenerator = '/qr-generator';
  static const String permissions = '/permissions';

  // Developer Routes (Debug only)
  static const String debug = '/debug';
  static const String logs = '/logs';
  static const String featureFlags = '/feature-flags';

  /// Get route with parameters
  static String getRouteWithParams(String route, Map<String, String> params) {
    String fullRoute = route;
    params.forEach((key, value) {
      fullRoute = fullRoute.replaceAll(':$key', value);
    });
    return fullRoute;
  }

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    const publicRoutes = [
      splash,
      onboarding,
      login,
      register,
      forgotPassword,
      verifyEmail,
      resetPassword,
      error,
      notFound,
      noInternet,
      maintenance,
    ];
    
    return !publicRoutes.contains(route);
  }

  /// Get route category
  static String getRouteCategory(String route) {
    if (route.startsWith('/auth') || _authRoutes.contains(route)) {
      return 'Authentication';
    } else if (route.startsWith('/chat') || _chatRoutes.contains(route)) {
      return 'Chat';
    } else if (route.startsWith('/call') || _callRoutes.contains(route)) {
      return 'Calls';
    } else if (route.startsWith('/contact') || _contactRoutes.contains(route)) {
      return 'Contacts';
    } else if (route.startsWith('/profile') || _profileRoutes.contains(route)) {
      return 'Profile';
    } else if (route.startsWith('/settings') || _settingsRoutes.contains(route)) {
      return 'Settings';
    } else if (route.startsWith('/media') || _mediaRoutes.contains(route)) {
      return 'Media';
    } else if (route.startsWith('/location') || _locationRoutes.contains(route)) {
      return 'Location';
    } else {
      return 'General';
    }
  }

  // Private route lists for categorization
  static const List<String> _authRoutes = [
    splash,
    onboarding,
    login,
    register,
    forgotPassword,
    verifyEmail,
    resetPassword,
  ];

  static const List<String> _chatRoutes = [
    chats,
    chatDetail,
    newChat,
    groupChat,
    createGroup,
    groupInfo,
    addParticipants,
  ];

  static const List<String> _callRoutes = [
    calls,
    videoCall,
    audioCall,
    incomingCall,
    callHistory,
  ];

  static const List<String> _contactRoutes = [
    contacts,
    addContact,
    contactInfo,
    inviteContacts,
    blockedContacts,
  ];

  static const List<String> _profileRoutes = [
    profile,
    editProfile,
    profilePhoto,
    profileSettings,
  ];

  static const List<String> _settingsRoutes = [
    settings,
    privacy,
    security,
    notifications,
    dataUsage,
    storage,
    language,
    theme,
    help,
    about,
    feedback,
  ];

  static const List<String> _mediaRoutes = [
    mediaViewer,
    imageViewer,
    videoPlayer,
    audioPlayer,
    documentViewer,
    gallery,
    camera,
  ];

  static const List<String> _locationRoutes = [
    location,
    shareLocation,
    nearbyUsers,
    locationHistory,
    geofencing,
  ];

  /// Get all routes for debugging
  static List<String> getAllRoutes() {
    return [
      ..._authRoutes,
      ..._chatRoutes,
      ..._callRoutes,
      ..._contactRoutes,
      ..._profileRoutes,
      ..._settingsRoutes,
      ..._mediaRoutes,
      ..._locationRoutes,
      home,
      dashboard,
      search,
      searchMessages,
      searchContacts,
      backup,
      restore,
      exportData,
      importData,
      error,
      notFound,
      noInternet,
      maintenance,
      webView,
      qrScanner,
      qrGenerator,
      permissions,
      debug,
      logs,
      featureFlags,
    ];
  }
}
