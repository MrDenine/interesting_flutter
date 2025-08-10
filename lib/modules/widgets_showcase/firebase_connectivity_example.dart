import 'package:flutter/material.dart';
import '../../shared/services/firebase/firebase.dart';

/// Example demonstrating Firebase connectivity utilities
class FirebaseConnectivityExample extends StatefulWidget {
  const FirebaseConnectivityExample({super.key});

  @override
  State<FirebaseConnectivityExample> createState() =>
      _FirebaseConnectivityExampleState();
}

class _FirebaseConnectivityExampleState
    extends State<FirebaseConnectivityExample> {
  FirebaseHealthStatus? _healthStatus;
  FirebaseMetrics? _metrics;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseStatus();
  }

  Future<void> _checkFirebaseStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if Firebase is already initialized
      final service = FirebaseService.instance;
      _isInitialized = service.isInitialized;

      // Get health status
      final health = await FirebaseUtils.performHealthCheck();
      final metrics = await FirebaseUtils.getConnectionMetrics();

      setState(() {
        _healthStatus = health;
        _metrics = metrics;
      });
    } catch (e) {
      debugPrint('Error checking Firebase status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await FirebaseUtils.initializeWithRetry();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Firebase initialized successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await _checkFirebaseStatus();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to initialize Firebase'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetConnection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await FirebaseUtils.resetConnection();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Firebase connection reset successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await _checkFirebaseStatus();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to reset Firebase connection'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connectivity'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Firebase Status',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildStatusRow(
                            'Initialized',
                            _isInitialized,
                            Icons.check_circle,
                            Icons.cancel,
                          ),
                          _buildStatusRow(
                            'Healthy',
                            _healthStatus?.isHealthy ?? false,
                            Icons.favorite,
                            Icons.warning,
                          ),
                          _buildStatusRow(
                            'Connected',
                            _healthStatus?.isConnected ?? false,
                            Icons.wifi,
                            Icons.wifi_off,
                          ),
                          _buildStatusRow(
                            'Internet',
                            _healthStatus?.hasInternet ?? false,
                            Icons.language,
                            Icons.signal_wifi_off,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metrics Card
                  if (_metrics != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connection Metrics',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            _buildMetricRow('Firebase Latency',
                                '${_metrics!.connectionLatencyMs}ms'),
                            _buildMetricRow('Internet Latency',
                                '${_metrics!.internetLatencyMs}ms'),
                            if (_metrics!.error != null)
                              _buildMetricRow('Error', _metrics!.error!),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Project Info Card
                  if (_healthStatus?.projectInfo.isNotEmpty == true)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Information',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            ..._healthStatus!.projectInfo.entries.map(
                              (entry) => _buildMetricRow(
                                  entry.key, entry.value.toString()),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Platform Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Platform Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          ...FirebaseUtils.getPlatformInfo().entries.map(
                                (entry) => _buildMetricRow(
                                    entry.key, entry.value.toString()),
                              ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      if (!_isInitialized)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _initializeFirebase,
                            icon: const Icon(Icons.power_settings_new),
                            label: const Text('Initialize Firebase'),
                          ),
                        ),
                      if (_isInitialized) ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _checkFirebaseStatus,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh Status'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _resetConnection,
                            icon: const Icon(Icons.restart_alt),
                            label: const Text('Reset Connection'),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Errors Card
                  if (_healthStatus?.errors.isNotEmpty == true)
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Errors',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            ..._healthStatus!.errors.map(
                              (error) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  '• $error',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusRow(
      String label, bool status, IconData successIcon, IconData failIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            status ? successIcon : failIcon,
            color: status ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            status ? 'Yes' : 'No',
            style: TextStyle(
              color: status ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
