import 'package:flutter/material.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_launch_model.dart';

/// Launch Details Bottom Sheet
class LaunchDetailsBottomSheet extends StatelessWidget {
  final SpaceXLaunch launch;

  const LaunchDetailsBottomSheet({super.key, required this.launch});

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(bool? success) {
    if (success == null) return Colors.orange;
    return success ? Colors.green : Colors.red;
  }

  String _getStatusText(bool? success) {
    if (success == null) return 'To Be Determined';
    return success ? 'Successful Launch' : 'Failed Launch';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      if (launch.links?.missionPatch != null)
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              launch.links!.missionPatch!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child:
                                      const Icon(Icons.rocket_launch, size: 40),
                                );
                              },
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              launch.missionName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(launch.launchSuccess),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _getStatusText(launch.launchSuccess),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Details
                  if (launch.details != null && launch.details!.isNotEmpty) ...[
                    const Text(
                      'Mission Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      launch.details!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Rocket info
                  if (launch.rocket != null) ...[
                    const Text(
                      'Rocket',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoCard([
                      _buildInfoRow('Name', launch.rocket!.name),
                      if (launch.rocket!.type != null)
                        _buildInfoRow('Type', launch.rocket!.type!),
                    ]),
                    const SizedBox(height: 16),
                  ],

                  // Launch site
                  if (launch.launchSite != null) ...[
                    const Text(
                      'Launch Site',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoCard([
                      _buildInfoRow('Site', launch.launchSite!.siteName),
                      if (launch.launchSite!.siteNameLong != null)
                        _buildInfoRow(
                            'Full Name', launch.launchSite!.siteNameLong!),
                    ]),
                    const SizedBox(height: 16),
                  ],

                  // Links
                  if (launch.links != null) ...[
                    const Text(
                      'Links',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (launch.links!.articleLink != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Open URL
                            },
                            icon: const Icon(Icons.article, size: 18),
                            label: const Text('Article'),
                          ),
                        if (launch.links!.videoLink != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Open URL
                            },
                            icon: const Icon(Icons.video_library, size: 18),
                            label: const Text('Video'),
                          ),
                        if (launch.links!.wikipedia != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Open URL
                            },
                            icon: const Icon(Icons.public, size: 18),
                            label: const Text('Wikipedia'),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
