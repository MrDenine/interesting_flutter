/// Example usage of the core exceptions module
///
/// This file demonstrates how to use the exception handling system
/// in your Flutter application.

import 'package:flutter/material.dart';
import 'package:interesting_flutter/core/exceptions/exceptions.dart';

/// Example service class demonstrating exception usage
class ExampleService {
  /// Example method that throws different types of exceptions
  Future<String> fetchData(String id) async {
    // Simulate network check
    if (!await _hasInternet()) {
      throw NoInternetException();
    }

    // Simulate data validation
    if (id.isEmpty) {
      throw DataValidationException(
        message: 'ID cannot be empty',
        validationErrors: {
          'id': ['Required field', 'Must not be empty']
        },
      );
    }

    // Simulate data not found
    if (id == 'not-found') {
      throw DataNotFoundException(
        message: 'Data with ID $id not found',
        resource: 'user-data',
        details: {'searchId': id},
      );
    }

    // Simulate server error
    if (id == 'server-error') {
      throw ServerException(
        statusCode: 500,
        message: 'Internal server error occurred',
        details: {'endpoint': '/api/data/$id'},
      );
    }

    // Simulate successful operation
    await Future.delayed(const Duration(milliseconds: 100));
    return 'Data for $id';
  }

  Future<bool> _hasInternet() async {
    // Simulate network check
    await Future.delayed(const Duration(milliseconds: 50));
    return true; // Change to false to simulate no internet
  }
}

/// Example widget demonstrating exception handling in UI
class ExampleExceptionHandlingWidget extends StatefulWidget {
  const ExampleExceptionHandlingWidget({super.key});

  @override
  State<ExampleExceptionHandlingWidget> createState() =>
      _ExampleExceptionHandlingWidgetState();
}

class _ExampleExceptionHandlingWidgetState
    extends State<ExampleExceptionHandlingWidget> {
  final ExampleService _service = ExampleService();
  String _status = 'Ready';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Setup global exception handler
    ExceptionHandler.instance.onException = (exception) {
      debugPrint('Global exception handler: ${exception.code}');

      // You could send to analytics here
      // analytics.recordException(exception);
    };
  }

  /// Example of basic exception handling
  Future<void> _fetchDataBasic(String id) async {
    setState(() {
      _isLoading = true;
      _status = 'Loading...';
    });

    try {
      final data = await _service.fetchData(id);
      setState(() {
        _status = 'Success: $data';
      });
    } catch (e) {
      // Convert any exception to AppException
      final appException = e.toAppException(
        context: 'Fetching data for $id',
        details: {'widget': 'ExampleWidget'},
      );

      // Get user-friendly message
      final userMessage =
          ExceptionHandler.instance.getUserMessage(appException);

      setState(() {
        _status = 'Error: $userMessage';
      });

      // Log the exception
      ExceptionHandler.instance.logException(appException);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Example using SafeExecution
  Future<void> _fetchDataSafe(String id) async {
    setState(() {
      _isLoading = true;
      _status = 'Loading with SafeExecution...';
    });

    final result = await SafeExecution.execute(
      () => _service.fetchData(id),
      context: 'Safe fetch for $id',
      fallback: 'Failed to load data',
      details: {'method': 'safe_execution'},
    );

    setState(() {
      _status = 'Result: $result';
      _isLoading = false;
    });
  }

  /// Example of handling specific exception types
  Future<void> _fetchDataWithSpecificHandling(String id) async {
    setState(() {
      _isLoading = true;
      _status = 'Loading with specific handling...';
    });

    try {
      final data = await _service.fetchData(id);
      setState(() {
        _status = 'Success: $data';
      });
    } on NoInternetException {
      setState(() {
        _status = 'No Internet: Please check your connection';
      });
      _showRetryDialog('No internet connection');
    } on DataNotFoundException catch (e) {
      setState(() {
        _status = 'Not Found: ${e.resource} not found';
      });
    } on ServerException catch (e) {
      setState(() {
        _status = 'Server Error: ${e.statusCode}';
      });
      if (e.statusCode >= 500) {
        _showRetryDialog('Server is having issues');
      }
    } on DataValidationException catch (e) {
      setState(() {
        _status = 'Validation Error: ${e.message}';
      });
      _showValidationErrors(e.validationErrors);
    } catch (e) {
      final appException = e.toAppException(context: 'Specific handling');
      setState(() {
        _status = 'Unexpected: ${appException.message}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRetryDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _fetchDataBasic('valid-id'); // Retry with valid ID
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showValidationErrors(Map<String, List<String>>? errors) {
    if (errors == null) return;

    final errorText =
        errors.entries.map((e) => '${e.key}: ${e.value.join(', ')}').join('\n');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Errors'),
        content: Text(errorText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exception Handling Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Test Different Exception Scenarios:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _fetchDataBasic('valid-id'),
              child: const Text('Success Case (Basic Handling)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _fetchDataBasic(''),
              child: const Text('Validation Error (Basic)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _fetchDataBasic('not-found'),
              child: const Text('Not Found Error (Basic)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed:
                  _isLoading ? null : () => _fetchDataBasic('server-error'),
              child: const Text('Server Error (Basic)'),
            ),
            const SizedBox(height: 20),
            const Text(
              'SafeExecution Examples:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _fetchDataSafe('valid-id'),
              child: const Text('Success with SafeExecution'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _fetchDataSafe('not-found'),
              child: const Text('Error with SafeExecution (Fallback)'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Specific Exception Handling:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  _isLoading ? null : () => _fetchDataWithSpecificHandling(''),
              child: const Text('Validation Error (Specific)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _fetchDataWithSpecificHandling('server-error'),
              child: const Text('Server Error (Specific)'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of creating custom exceptions for your domain
class UserRegistrationException extends BusinessLogicException {
  final String userId;
  final String step;

  UserRegistrationException({
    required this.userId,
    required this.step,
    required super.message,
  }) : super(
          code: 'user_registration_error',
          details: {
            'userId': userId,
            'registrationStep': step,
          },
        );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'userId': userId,
        'step': step,
      };
}

/// Example of exception handling in a repository pattern
class UserRepository {
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      // Validate input
      if (userData['email']?.isEmpty ?? true) {
        throw DataValidationException(
          message: 'Email is required for user creation',
          validationErrors: {
            'email': ['Required field', 'Cannot be empty']
          },
        );
      }

      // Simulate network call
      await Future.delayed(const Duration(milliseconds: 200));

      // Simulate different failure scenarios
      if (userData['email'] == 'existing@example.com') {
        throw UserRegistrationException(
          userId: userData['id'] ?? 'unknown',
          step: 'email_validation',
          message: 'Email already exists',
        );
      }

      return User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: userData['email'],
        name: userData['name'] ?? 'Unknown',
      );
    } catch (e) {
      // If it's already an AppException, rethrow
      if (e is AppException) {
        rethrow;
      }

      // Convert unknown exceptions
      throw e.toAppException(
        context: 'Creating user',
        details: {'userData': userData},
      );
    }
  }
}

/// Example user model
class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}
