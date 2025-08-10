import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// Utility class for Firebase connectivity and health checks
class FirebaseUtils {
  FirebaseUtils._();

  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      if (kIsWeb) {
        // For web, we can't directly check connectivity
        // So we'll assume connection is available
        return true;
      }

      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Error checking internet connection: $e');
      return false;
    }
  }

  /// Check Firebase service availability
  static Future<bool> isFirebaseAvailable() async {
    try {
      final service = FirebaseService.instance;

      if (!service.isInitialized) {
        debugPrint('Firebase not initialized');
        return false;
      }

      // Check if we can access Firebase
      return await service.checkConnection();
    } catch (e) {
      debugPrint('Error checking Firebase availability: $e');
      return false;
    }
  }

  /// Perform comprehensive Firebase health check
  static Future<FirebaseHealthStatus> performHealthCheck() async {
    final healthStatus = FirebaseHealthStatus();

    try {
      // Check internet connection
      healthStatus.hasInternet = await hasInternetConnection();

      // Check Firebase initialization
      final service = FirebaseService.instance;
      healthStatus.isInitialized = service.isInitialized;

      if (healthStatus.isInitialized) {
        // Check Firebase connection
        healthStatus.isConnected = await service.checkConnection();

        // Get project info
        healthStatus.projectInfo = service.getProjectInfo();

        // Check if configuration is valid
        if (healthStatus.projectInfo.containsKey('error')) {
          healthStatus.configurationValid = false;
          healthStatus.errors.add('Invalid Firebase configuration');
        } else {
          healthStatus.configurationValid = true;
        }
      } else {
        healthStatus.errors.add('Firebase not initialized');
      }

      // Overall health status
      healthStatus.isHealthy = healthStatus.hasInternet &&
          healthStatus.isInitialized &&
          healthStatus.isConnected &&
          healthStatus.configurationValid;
    } catch (e) {
      healthStatus.isHealthy = false;
      healthStatus.errors.add('Health check failed: $e');
      debugPrint('Firebase health check error: $e');
    }

    return healthStatus;
  }

  /// Initialize Firebase with retry logic
  static Future<bool> initializeWithRetry({
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        attempts++;
        debugPrint('Firebase initialization attempt $attempts/$maxRetries');

        await FirebaseService.instance.initialize();
        debugPrint('Firebase initialized successfully');
        return true;
      } catch (e) {
        debugPrint('Firebase initialization attempt $attempts failed: $e');

        if (attempts >= maxRetries) {
          debugPrint('All Firebase initialization attempts failed');
          return false;
        }

        // Wait before retrying
        await Future.delayed(retryDelay);
      }
    }

    return false;
  }

  /// Wait for Firebase to be ready
  static Future<bool> waitForFirebaseReady({
    Duration timeout = const Duration(seconds: 30),
    Duration checkInterval = const Duration(milliseconds: 500),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      try {
        final isReady = await isFirebaseAvailable();
        if (isReady) {
          debugPrint(
              'Firebase is ready after ${stopwatch.elapsed.inMilliseconds}ms');
          return true;
        }

        await Future.delayed(checkInterval);
      } catch (e) {
        debugPrint('Error while waiting for Firebase: $e');
        await Future.delayed(checkInterval);
      }
    }

    debugPrint('Firebase not ready after ${timeout.inSeconds} seconds');
    return false;
  }

  /// Get Firebase connection metrics
  static Future<FirebaseMetrics> getConnectionMetrics() async {
    final metrics = FirebaseMetrics();
    final stopwatch = Stopwatch();

    try {
      // Test connection latency
      stopwatch.start();
      final isConnected = await FirebaseService.instance.checkConnection();
      stopwatch.stop();

      metrics.connectionLatencyMs = stopwatch.elapsedMilliseconds;
      metrics.isConnected = isConnected;

      // Get health status
      final healthStatus = await performHealthCheck();
      metrics.healthStatus = healthStatus;

      // Test internet speed (basic check)
      stopwatch.reset();
      stopwatch.start();
      final hasInternet = await hasInternetConnection();
      stopwatch.stop();

      metrics.internetLatencyMs = stopwatch.elapsedMilliseconds;
      metrics.hasInternet = hasInternet;
    } catch (e) {
      metrics.error = e.toString();
      debugPrint('Error getting Firebase metrics: $e');
    }

    return metrics;
  }

  /// Reset Firebase connection
  static Future<bool> resetConnection() async {
    try {
      debugPrint('Resetting Firebase connection...');

      final service = FirebaseService.instance;
      await service.reinitialize();

      // Wait for connection to be ready
      final isReady = await waitForFirebaseReady();

      if (isReady) {
        debugPrint('Firebase connection reset successfully');
        return true;
      } else {
        debugPrint('Firebase connection reset failed');
        return false;
      }
    } catch (e) {
      debugPrint('Error resetting Firebase connection: $e');
      return false;
    }
  }

  /// Get platform-specific Firebase information
  static Map<String, dynamic> getPlatformInfo() {
    return {
      'platform': defaultTargetPlatform.name,
      'isWeb': kIsWeb,
      'isDebugMode': kDebugMode,
      'isProfileMode': kProfileMode,
      'isReleaseMode': kReleaseMode,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Firebase health status model
class FirebaseHealthStatus {
  bool hasInternet = false;
  bool isInitialized = false;
  bool isConnected = false;
  bool configurationValid = false;
  bool isHealthy = false;
  Map<String, dynamic> projectInfo = {};
  List<String> errors = [];
  DateTime timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
        'hasInternet': hasInternet,
        'isInitialized': isInitialized,
        'isConnected': isConnected,
        'configurationValid': configurationValid,
        'isHealthy': isHealthy,
        'projectInfo': projectInfo,
        'errors': errors,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  String toString() =>
      'FirebaseHealthStatus(healthy: $isHealthy, errors: ${errors.length})';
}

/// Firebase connection metrics model
class FirebaseMetrics {
  int connectionLatencyMs = 0;
  int internetLatencyMs = 0;
  bool isConnected = false;
  bool hasInternet = false;
  FirebaseHealthStatus? healthStatus;
  String? error;
  DateTime timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
        'connectionLatencyMs': connectionLatencyMs,
        'internetLatencyMs': internetLatencyMs,
        'isConnected': isConnected,
        'hasInternet': hasInternet,
        'healthStatus': healthStatus?.toJson(),
        'error': error,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  String toString() =>
      'FirebaseMetrics(connected: $isConnected, latency: ${connectionLatencyMs}ms)';
}
