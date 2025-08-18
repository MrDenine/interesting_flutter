import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Generic GraphQL configuration utility
class GraphQLConfig {
  /// Create GraphQL client with custom endpoint
  static GraphQLClient createClient(String endpoint) {
    final httpLink = HttpLink(endpoint);

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  /// Create Value Notifier for GraphQL client with custom endpoint
  static ValueNotifier<GraphQLClient> createClientNotifier(String endpoint) {
    return ValueNotifier<GraphQLClient>(createClient(endpoint));
  }
}
