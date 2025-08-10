# Firebase Utilities

This module provides comprehensive Firebase connectivity and management utilities for the Flutter application.

## Overview

The Firebase utilities package offers robust connection management, health monitoring, and platform-specific configuration support for Firebase integration.

## Components

### 1. FirebaseService (`firebase_service.dart`)

The core Firebase initialization and connection management service with singleton pattern.

**Key Features:**

- Singleton pattern for global access
- Platform-specific initialization
- Connection status checking
- Error handling with custom exceptions
- Reinitialization support

**Usage:**

```dart
// Initialize Firebase
await FirebaseService.instance.initialize();

// Check if initialized
final isInitialized = FirebaseService.instance.isInitialized;

// Check connection
final isConnected = await FirebaseService.instance.checkConnection();

// Get project information
final projectInfo = FirebaseService.instance.getProjectInfo();
```

### 2. FirebaseConfig (`firebase_config.dart`)

Platform-specific Firebase configuration with validation.

**Key Features:**

- Platform-specific FirebaseOptions
- Configuration validation
- Environment-based configuration
- Support for Web, Android, iOS, macOS, Windows

**Platform Support:**

- **Web**: Firebase web configuration
- **Android**: Android app configuration
- **iOS**: iOS app configuration
- **macOS**: macOS app configuration
- **Windows**: Windows app configuration

**Usage:**

```dart
// Get configuration for current platform
final config = FirebaseConfig.currentPlatform;

// Validate configuration
final isValid = FirebaseConfig.validateConfiguration(config);
```

### 3. FirebaseUtils (`firebase_utils.dart`)

Utility functions for connectivity, health checks, and diagnostics.

**Key Features:**

- Internet connectivity checking
- Firebase availability testing
- Comprehensive health checks
- Connection metrics
- Retry logic for initialization
- Connection reset functionality

**Usage:**

```dart
// Check internet connectivity
final hasInternet = await FirebaseUtils.hasInternetConnection();

// Check Firebase availability
final isAvailable = await FirebaseUtils.isFirebaseAvailable();

// Perform health check
final health = await FirebaseUtils.performHealthCheck();

// Initialize with retry
final success = await FirebaseUtils.initializeWithRetry(maxRetries: 3);

// Get connection metrics
final metrics = await FirebaseUtils.getConnectionMetrics();

// Reset connection
final resetSuccess = await FirebaseUtils.resetConnection();
```

### 4. Firebase Connectivity Example (`firebase_connectivity_example.dart`)

A complete Flutter widget demonstrating Firebase utilities usage.

**Features:**

- Real-time status monitoring
- Health check visualization
- Connection metrics display
- Initialize/Reset functionality
- Error handling and reporting

## Data Models

### FirebaseHealthStatus

```dart
class FirebaseHealthStatus {
  bool hasInternet;
  bool isInitialized;
  bool isConnected;
  bool configurationValid;
  bool isHealthy;
  Map<String, dynamic> projectInfo;
  List<String> errors;
  DateTime timestamp;
}
```

### FirebaseMetrics

```dart
class FirebaseMetrics {
  int connectionLatencyMs;
  int internetLatencyMs;
  bool isConnected;
  bool hasInternet;
  FirebaseHealthStatus? healthStatus;
  String? error;
  DateTime timestamp;
}
```

## Error Handling

### FirebaseInitializationException

Custom exception for Firebase initialization errors.

```dart
class FirebaseInitializationException implements Exception {
  final String message;
  final String code;

  const FirebaseInitializationException(this.message, this.code);
}
```

## Installation

Add the required dependency to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.6.0
```

Then run:

```bash
flutter pub get
```

## Configuration Setup

1. **Web Configuration**: Update `FirebaseConfig.web` with your web app config
2. **Android Configuration**: Update `FirebaseConfig.android` with your Android app config
3. **iOS Configuration**: Update `FirebaseConfig.ios` with your iOS app config
4. **macOS Configuration**: Update `FirebaseConfig.macos` with your macOS app config
5. **Windows Configuration**: Update `FirebaseConfig.windows` with your Windows app config

### Example Configuration

```dart
static const web = FirebaseOptions(
  apiKey: 'your-web-api-key',
  appId: 'your-web-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-project.firebaseapp.com',
  storageBucket: 'your-project.appspot.com',
);
```

## Platform Support

| Platform | Supported | Notes                                            |
| -------- | --------- | ------------------------------------------------ |
| Web      | ✅        | Full support with web-specific configuration     |
| Android  | ✅        | Full support with Android-specific configuration |
| iOS      | ✅        | Full support with iOS-specific configuration     |
| macOS    | ✅        | Full support with macOS-specific configuration   |
| Windows  | ✅        | Full support with Windows-specific configuration |
| Linux    | ⚠️        | Basic support (uses default configuration)       |

## Integration Example

```dart
import 'package:interesting_flutter/shared/services/firebase/firebase.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirebaseReady = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      // Initialize Firebase with retry
      final success = await FirebaseUtils.initializeWithRetry();

      if (success) {
        // Wait for Firebase to be ready
        final isReady = await FirebaseUtils.waitForFirebaseReady();

        setState(() {
          _isFirebaseReady = isReady;
        });

        // Perform health check
        final health = await FirebaseUtils.performHealthCheck();
        print('Firebase Health: ${health.isHealthy}');
      }
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isFirebaseReady
          ? HomeScreen()
          : LoadingScreen(),
    );
  }
}
```

## Best Practices

1. **Initialization**: Always initialize Firebase before using other Firebase services
2. **Error Handling**: Implement proper error handling for network and configuration issues
3. **Health Monitoring**: Regularly check Firebase health status in production apps
4. **Retry Logic**: Use retry logic for initialization in unreliable network conditions
5. **Configuration**: Keep Firebase configuration secure and environment-specific

## Troubleshooting

### Common Issues

1. **Initialization Fails**

   - Check network connectivity
   - Verify Firebase configuration
   - Check platform-specific setup

2. **Connection Issues**

   - Verify internet connection
   - Check Firebase project status
   - Review security rules

3. **Configuration Errors**
   - Ensure all required fields are provided
   - Verify API keys and project IDs
   - Check platform-specific configuration

### Debug Information

Use the Firebase connectivity example widget to get detailed diagnostic information:

- Internet connectivity status
- Firebase initialization status
- Connection latency metrics
- Configuration validation
- Error reporting

## Contributing

When adding new Firebase utilities:

1. Follow the existing code structure
2. Add comprehensive error handling
3. Include proper documentation
4. Add unit tests where appropriate
5. Update this README with new features

## License

This Firebase utilities module is part of the Interesting Flutter project.
