import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interesting_flutter/core/utils/date_utils.dart';
import 'package:interesting_flutter/presentation/providers/spacex_state.dart';
import 'package:interesting_flutter/presentation/screens/spacex/spacex_launch_details_buttom_sheet.dart';
import '../../providers/spacex_providers.dart';
import '../../../data/models/spacex/spacex_launch_model.dart';

/// SpaceX Launches Screen
class SpaceXLaunchesScreen extends ConsumerStatefulWidget {
  const SpaceXLaunchesScreen({super.key});

  @override
  ConsumerState<SpaceXLaunchesScreen> createState() =>
      _SpaceXLaunchesScreenState();
}

class _SpaceXLaunchesScreenState extends ConsumerState<SpaceXLaunchesScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch the launches provider
    final launchesAsync =
        ref.watch(launchesProvider(const LaunchesParams(limit: 20, offset: 0)));

    return Scaffold(
      body: launchesAsync.when(
        data: (launches) => _buildLaunchesList(launches),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading SpaceX launches...'),
            ],
          ),
        ),
        error: (error, stack) => _buildErrorWidget(error),
      ),
    );
  }

  Widget _buildLaunchesList(List<SpaceXLaunch> launches) {
    if (launches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No launches found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(launchesProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: launches.length,
        itemBuilder: (context, index) {
          final launch = launches[index];
          return _buildLaunchCard(launch);
        },
      ),
    );
  }

  Widget _buildLaunchCard(SpaceXLaunch launch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: () => _showLaunchDetails(launch),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Mission patch image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: launch.links?.missionPatchSmall != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              launch.links!.missionPatchSmall!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.rocket_launch,
                                    size: 30);
                              },
                            ),
                          )
                        : const Icon(Icons.rocket_launch, size: 30),
                  ),
                  const SizedBox(width: 16),
                  // Mission info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          launch.missionName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (launch.rocket != null)
                          Text(
                            'Rocket: ${launch.rocket!.rocketName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        if (launch.launchDateLocal != null)
                          Text(
                            formatDateString(launch.launchDateLocal!),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Success indicator
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(launch.launchSuccess),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(launch.launchSuccess),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (launch.details != null && launch.details!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  launch.details!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load launches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(launchesProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLaunchDetails(SpaceXLaunch launch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LaunchDetailsBottomSheet(launch: launch),
    );
  }

  Color _getStatusColor(bool? success) {
    if (success == null) return Colors.orange;
    return success ? Colors.green : Colors.red;
  }

  String _getStatusText(bool? success) {
    if (success == null) return 'TBD';
    return success ? 'Success' : 'Failed';
  }
}
