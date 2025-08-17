import 'package:flutter/material.dart';
import 'package:interesting_flutter/presentation/widgets/common/menu_card.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Interesting Flutter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                Text(
                  'Interesting Flutter',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover amazing Flutter widgets and explore powerful features',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
                const SizedBox(height: 32),

                // Main Menu Cards
                Expanded(
                  child: Column(
                    children: [
                      // Widget Menu Card
                      MenuCard(
                        title: 'Widget',
                        subtitle: 'Explore Flutter widget collection',
                        description:
                            'Browse through 9 categories of interactive widgets with live examples',
                        icon: Icons.widgets,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.7),
                          ],
                        ),
                        onTap: () => AppNavigator.goToWidgetCategory(context),
                      ),
                      const SizedBox(height: 16),

                      // Feature and Utility Menu Card
                      MenuCard(
                        title: 'Feature and Utility',
                        subtitle: 'Advanced features and tools',
                        description:
                            'Discover powerful utilities and advanced Flutter features',
                        icon: Icons.build_circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.7),
                          ],
                        ),
                        isComingSoon: true,
                        onTap: () => _showComingSoonDialog(context),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show coming soon dialog
  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.construction,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          'Coming Soon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: Text(
          'Feature and Utility section is under development. Stay tuned for exciting new features!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
