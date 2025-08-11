/// Firebase services and utilities
///
/// This module provides comprehensive Firebase connectivity and management
/// utilities for the Flutter application.
///
/// Key components:
/// - [FirebaseService]: Core Firebase initialization and connection management
/// - [FirebaseConfig]: Platform-specific Firebase configuration
/// - [FirebaseUtils]: Utility functions for health checks and connectivity
///
/// Usage:
/// ```dart
/// import 'package:interesting_flutter/core/services/firebase/firebase.dart';
///
/// // Initialize Firebase
/// await FirebaseService.instance.initialize();
///
/// // Check connection
/// final isConnected = await FirebaseUtils.isFirebaseAvailable();
///
/// // Perform health check
/// final health = await FirebaseUtils.performHealthCheck();
/// ```
library;

export 'firebase_service.dart';
export 'firebase_config.dart';
export 'firebase_utils.dart';
