# NeruTalk

A modern, feature-rich chat application built with Flutter and powered by GetX state management. NeruTalk provides real-time messaging, multimedia sharing, voice/video calls, and advanced privacy features.

## Features

### Core Messaging
- Real-time messaging with WebSocket integration
- Rich text formatting and message reactions
- Media sharing (images, videos, documents, audio)
- Voice messages and file attachments
- Message encryption and security
- Read receipts and typing indicators

### Communication
- High-quality voice and video calling
- Group chats with advanced management
- Channel broadcasting
- Screen sharing capabilities
- Call history and recording

### User Experience
- Multi-language support (English, Chinese, Japanese, Korean, Indonesian)
- Dark and light theme modes
- Customizable notification preferences
- Advanced privacy and security settings
- Profile management and customization

### Technical Features
- Offline capability with local storage
- Push notifications
- Location sharing
- Contact management
- Search and filtering
- Cross-platform compatibility

## Architecture

NeruTalk follows clean architecture principles with clear separation of concerns:

```
lib/
├── app/                 # App-level configuration
├── core/               # Core utilities and services
│   ├── config/        # App configuration
│   ├── constants/     # Constants and strings
│   ├── services/      # Business logic services
│   ├── theme/         # App theming
│   └── utils/         # Utility functions
├── data/              # Data layer
│   ├── datasources/   # API and local data sources
│   ├── models/        # Data models
│   └── repositories/  # Repository implementations
├── domain/            # Domain layer
│   ├── entities/      # Business entities
│   ├── models/        # Domain models
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business use cases
└── presentation/      # Presentation layer
    ├── controllers/   # GetX controllers
    ├── pages/         # UI screens
    ├── routes/        # Navigation and routing
    └── widgets/       # Reusable UI components
```

## Technology Stack

- **Framework**: Flutter 3.x
- **State Management**: GetX
- **Local Storage**: Hive, SQLite, Shared Preferences
- **Security**: Flutter Secure Storage, Crypto
- **Networking**: Dio HTTP Client
- **Real-time**: Socket.IO Client
- **UI**: Material Design 3, Google Fonts
- **Internationalization**: Flutter Intl
- **Media**: Image Picker, File Picker
- **Platform Services**: Permission Handler, Connectivity Plus

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- iOS development tools (for iOS builds)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/nerutalk.git
   cd nerutalk
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate necessary files:
   ```bash
   flutter packages pub run build_runner build
   ```

4. Run the application:
   ```bash
   flutter run
   ```

### Development Setup

1. Configure your development environment:
   ```bash
   flutter doctor
   ```

2. Set up platform-specific configurations:
   - **Android**: Configure `android/app/build.gradle`
   - **iOS**: Configure `ios/Runner.xcodeproj`

3. Initialize required services (when implementing):
   - Firebase for push notifications
   - Backend API endpoints
   - Authentication providers

## Configuration

### Environment Setup

Create environment-specific configuration in `lib/core/config/`:

```dart
class AppConfig {
  static const String appName = 'NeruTalk';
  static const String version = '1.0.0';
  static const String apiBaseUrl = 'https://api.nerutalk.com';
  // Add your configuration
}
```

### Localization

Add new translations in `assets/translations/`:
- `en.json` - English
- `cn.json` - Chinese
- `jp.json` - Japanese
- `ko.json` - Korean
- `id.json` - Indonesian

## Testing

Run tests using Flutter's testing framework:

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

## Building

### Debug Build
```bash
flutter build apk --debug
flutter build ios --debug
```

### Release Build
```bash
flutter build apk --release
flutter build ios --release
```

## API Integration

NeruTalk is designed to work with a RESTful backend API. Key endpoints include:

- Authentication: `/auth/login`, `/auth/register`
- Messaging: `/messages`, `/chats`
- Users: `/users`, `/contacts`
- Media: `/upload`, `/media`
- Notifications: `/notifications`

Refer to the API documentation for complete endpoint specifications.

## Contributing

We welcome contributions to NeruTalk. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards

- Follow Dart/Flutter style guidelines
- Write comprehensive tests for new features
- Update documentation for API changes
- Use meaningful commit messages
- Ensure code passes all lint checks

## Security

NeruTalk implements multiple security layers:

- End-to-end message encryption
- Secure local storage
- Authentication token management
- Privacy controls
- Data protection compliance

Report security vulnerabilities to: security@nerutalk.com

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:

- Documentation: [docs.nerutalk.com](https://docs.nerutalk.com)
- Issues: [GitHub Issues](https://github.com/your-org/nerutalk/issues)
- Email: support@nerutalk.com
- Community: [Discord](https://discord.gg/nerutalk)

## Roadmap

- [ ] End-to-end encryption implementation
- [ ] Voice message transcription
- [ ] Advanced group management
- [ ] Message scheduling
- [ ] Desktop application
- [ ] Web application
- [ ] AI-powered features
- [ ] Enterprise features

## Acknowledgments

- Flutter team for the amazing framework
- GetX community for state management
- Contributors and beta testers
- Open source packages and libraries

---

**NeruTalk** - Connecting conversations, enhancing communication.
