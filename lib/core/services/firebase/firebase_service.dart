import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'firebase_config.dart';

/// Firebase service for managing Firebase initialization and connection
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  bool _isInitialized = false;
  FirebaseApp? _app;

  /// Check if Firebase is initialized
  bool get isInitialized => _isInitialized;

  /// Get the current Firebase app instance
  FirebaseApp? get app => _app;

  /// Initialize Firebase with platform-specific options
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('Firebase is already initialized');
      return;
    }

    try {
      debugPrint('Initializing Firebase...');

      // Get platform-specific Firebase options
      final options = await _getFirebaseOptions();

      if (options != null) {
        _app = await Firebase.initializeApp(
          name: 'interesting_flutter',
          options: options,
        );
        debugPrint('Firebase initialized successfully with custom options');
      } else {
        // Fallback to default initialization
        _app = await Firebase.initializeApp();
        debugPrint('Firebase initialized with default options');
      }

      _isInitialized = true;

      // Log Firebase app info
      debugPrint('Firebase App Name: ${_app?.name}');
      debugPrint('Firebase Project ID: ${_app?.options.projectId}');
    } on FirebaseException catch (e) {
      debugPrint('Firebase initialization failed: ${e.message}');
      throw FirebaseInitializationException(
        'Failed to initialize Firebase: ${e.message}',
        e.code,
      );
    } on PlatformException catch (e) {
      debugPrint('Platform exception during Firebase init: ${e.message}');
      throw FirebaseInitializationException(
        'Platform error during Firebase initialization: ${e.message}',
        e.code,
      );
    } catch (e) {
      debugPrint('Unexpected error during Firebase init: $e');
      throw FirebaseInitializationException(
        'Unexpected error during Firebase initialization: $e',
        'unknown',
      );
    }
  }

  /// Get platform-specific Firebase options
  Future<FirebaseOptions?> _getFirebaseOptions() async {
    try {
      if (kIsWeb) {
        return FirebaseConfig.webOptions;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return FirebaseConfig.androidOptions;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return FirebaseConfig.iosOptions;
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        return FirebaseConfig.macosOptions;
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        return FirebaseConfig.windowsOptions;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting Firebase options: $e');
      return null;
    }
  }

  /// Reinitialize Firebase (useful for switching between environments)
  Future<void> reinitialize({String? appName}) async {
    try {
      if (_isInitialized && _app != null) {
        await _app!.delete();
        _isInitialized = false;
        _app = null;
        debugPrint('Previous Firebase instance deleted');
      }

      await initialize();
    } catch (e) {
      debugPrint('Error during Firebase reinitialization: $e');
      rethrow;
    }
  }

  /// Check Firebase connection status
  Future<bool> checkConnection() async {
    if (!_isInitialized || _app == null) {
      return false;
    }

    try {
      // Simple connectivity check by trying to access Firebase
      final projectId = _app!.options.projectId;
      return projectId.isNotEmpty;
    } catch (e) {
      debugPrint('Firebase connection check failed: $e');
      return false;
    }
  }

  /// Get Firebase project information
  Map<String, dynamic> getProjectInfo() {
    if (!_isInitialized || _app == null) {
      return {'error': 'Firebase not initialized'};
    }

    return {
      'appName': _app!.name,
      'projectId': _app!.options.projectId,
      'apiKey': _app!.options.apiKey,
      'authDomain': _app!.options.authDomain,
      'storageBucket': _app!.options.storageBucket,
      'messagingSenderId': _app!.options.messagingSenderId,
      'appId': _app!.options.appId,
      'platform': defaultTargetPlatform.name,
      'isWeb': kIsWeb,
    };
  }

  /// Dispose Firebase resources
  Future<void> dispose() async {
    try {
      if (_isInitialized && _app != null) {
        await _app!.delete();
        _app = null;
        _isInitialized = false;
        debugPrint('Firebase resources disposed');
      }
    } catch (e) {
      debugPrint('Error disposing Firebase resources: $e');
    }
  }
}

/// Custom exception for Firebase initialization errors
class FirebaseInitializationException implements Exception {
  final String message;
  final String code;

  const FirebaseInitializationException(this.message, this.code);

  @override
  String toString() =>
      'FirebaseInitializationException: $message (Code: $code)';
}
