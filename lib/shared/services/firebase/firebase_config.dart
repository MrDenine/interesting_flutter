import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration class containing platform-specific options
///
/// This class holds the Firebase configuration for different platforms.
/// Replace the placeholder values with your actual Firebase project configuration.
///
/// To get these values:
/// 1. Go to Firebase Console (https://console.firebase.google.com/)
/// 2. Select your project or create a new one
/// 3. Go to Project Settings > General
/// 4. Add apps for each platform you want to support
/// 5. Copy the configuration values from each platform
class FirebaseConfig {
  // Private constructor to prevent instantiation
  FirebaseConfig._();

  /// Web Firebase options
  /// Get these from: Firebase Console > Project Settings > General > Web apps
  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey: "your-web-api-key",
    authDomain: "your-project-id.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abcdef123456",
    measurementId: "G-XXXXXXXXXX", // Optional: Google Analytics
  );

  /// Android Firebase options
  /// Get these from: Firebase Console > Project Settings > General > Android apps
  /// Or from your google-services.json file
  static const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: "your-android-api-key",
    appId: "1:123456789:android:abcdef123456",
    messagingSenderId: "123456789",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    authDomain: "your-project-id.firebaseapp.com",
  );

  /// iOS Firebase options
  /// Get these from: Firebase Console > Project Settings > General > iOS apps
  /// Or from your GoogleService-Info.plist file
  static const FirebaseOptions iosOptions = FirebaseOptions(
    apiKey: "your-ios-api-key",
    appId: "1:123456789:ios:abcdef123456",
    messagingSenderId: "123456789",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    authDomain: "your-project-id.firebaseapp.com",
    iosBundleId: "com.example.your-app",
  );

  /// macOS Firebase options
  /// Get these from: Firebase Console > Project Settings > General > macOS apps
  static const FirebaseOptions macosOptions = FirebaseOptions(
    apiKey: "your-macos-api-key",
    appId: "1:123456789:ios:abcdef123456", // Often same as iOS
    messagingSenderId: "123456789",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    authDomain: "your-project-id.firebaseapp.com",
    iosBundleId: "com.example.your-app.macos",
  );

  /// Windows Firebase options
  /// Currently, Firebase has limited support for Windows
  /// These options might need to be adjusted based on your setup
  static const FirebaseOptions windowsOptions = FirebaseOptions(
    apiKey: "your-windows-api-key",
    appId: "1:123456789:web:abcdef123456", // Often same as web
    messagingSenderId: "123456789",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    authDomain: "your-project-id.firebaseapp.com",
  );

  /// Development environment options
  /// Use these for local development with Firebase emulators
  static const FirebaseOptions developmentOptions = FirebaseOptions(
    apiKey: "demo-project-api-key",
    authDomain: "demo-project.firebaseapp.com",
    projectId: "demo-project",
    storageBucket: "demo-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:demo",
  );

  /// Get options based on environment
  static FirebaseOptions getOptionsForEnvironment(String environment) {
    switch (environment.toLowerCase()) {
      case 'development':
      case 'dev':
        return developmentOptions;
      case 'staging':
      case 'test':
        // You can add staging-specific options here
        return webOptions; // Fallback to production for now
      case 'production':
      case 'prod':
      default:
        return webOptions; // Default to web options
    }
  }

  /// Validate if Firebase options are properly configured
  static bool validateOptions(FirebaseOptions options) {
    // Check for placeholder values that need to be replaced
    if (options.apiKey.contains('your-') ||
        options.projectId.contains('your-') ||
        options.appId.contains('your-')) {
      return false;
    }

    // Check for required fields
    if (options.apiKey.isEmpty ||
        options.projectId.isEmpty ||
        options.appId.isEmpty ||
        options.messagingSenderId.isEmpty) {
      return false;
    }

    return true;
  }

  /// Get configuration summary
  static Map<String, dynamic> getConfigSummary() {
    return {
      'platforms': [
        {
          'name': 'Web',
          'configured': validateOptions(webOptions),
          'projectId': webOptions.projectId,
        },
        {
          'name': 'Android',
          'configured': validateOptions(androidOptions),
          'projectId': androidOptions.projectId,
        },
        {
          'name': 'iOS',
          'configured': validateOptions(iosOptions),
          'projectId': iosOptions.projectId,
        },
        {
          'name': 'macOS',
          'configured': validateOptions(macosOptions),
          'projectId': macosOptions.projectId,
        },
        {
          'name': 'Windows',
          'configured': validateOptions(windowsOptions),
          'projectId': windowsOptions.projectId,
        },
      ],
      'environments': ['development', 'staging', 'production'],
    };
  }
}
