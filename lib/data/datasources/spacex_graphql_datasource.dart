import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:interesting_flutter/data/datasources/spacex_graphql_query.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_company_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_rocket_model.dart';
import '../models/spacex/spacex_launch_model.dart';
import '../../core/services/graphql/graphql_config.dart';
import 'spacex_datasource_interface.dart';

/// SpaceX GraphQL data source implementation
class SpaceXGraphQLDataSource implements SpaceXDataSourceInterface {
  /// SpaceX GraphQL API endpoint
  static const String endpoint = 'https://spacex-production.up.railway.app/';

  final GraphQLClient _client;

  SpaceXGraphQLDataSource({GraphQLClient? client})
      : _client = client ?? GraphQLConfig.createClient(endpoint);

  @override
  Future<List<SpaceXLaunch>> getLaunches({
    int? limit = 20,
    int? offset = 0,
  }) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getAllLaunches),
        variables: {
          'limit': limit,
          'offset': offset,
        },
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch launches: ${result.exception.toString()}');
      }

      final List<dynamic> launchesData = result.data?['launches'] ?? [];
      return launchesData
          .map((launch) => SpaceXLaunch.fromJson(launch))
          .toList();
    } catch (e) {
      throw Exception('Error fetching launches: $e');
    }
  }

  @override
  Future<SpaceXLaunch?> getLaunchById(String id) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getLaunchById),
        variables: {'id': id},
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch launch: ${result.exception.toString()}');
      }

      final Map<String, dynamic>? launchData = result.data?['launch'];
      if (launchData == null) return null;

      return SpaceXLaunch.fromJson(launchData);
    } catch (e) {
      throw Exception('Error fetching launch by ID: $e');
    }
  }

  @override
  Future<List<SpaceXRocket>> getRockets() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getAllRockets),
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch rockets: ${result.exception.toString()}');
      }

      final List<dynamic> rocketsData = result.data?['rockets'] ?? [];
      return rocketsData
          .map((rocket) => SpaceXRocket.fromJson(rocket))
          .toList();
    } catch (e) {
      throw Exception('Error fetching rockets: $e');
    }
  }

  @override
  Future<SpaceXRocket?> getRocketById(String id) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getRocketById),
        variables: {'id': id},
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch rocket: ${result.exception.toString()}');
      }

      final Map<String, dynamic>? rocketData = result.data?['rocket'];
      if (rocketData == null) return null;

      return SpaceXRocket.fromJson(rocketData);
    } catch (e) {
      throw Exception('Error fetching rocket by ID: $e');
    }
  }

  @override
  Future<List<SpaceXLaunch>> getUpcomingLaunches({int? limit = 10}) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getUpcomingLaunches),
        variables: {'limit': limit},
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch upcoming launches: ${result.exception.toString()}');
      }

      final List<dynamic> launchesData = result.data?['launchesUpcoming'] ?? [];
      return launchesData
          .map((launch) => SpaceXLaunch.fromJson(launch))
          .toList();
    } catch (e) {
      throw Exception('Error fetching upcoming launches: $e');
    }
  }

  @override
  Future<List<SpaceXLaunch>> getPastLaunches({
    int? limit = 20,
    int? offset = 0,
  }) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getPastLaunches),
        variables: {
          'limit': limit,
          'offset': offset,
        },
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch past launches: ${result.exception.toString()}');
      }

      final List<dynamic> launchesData = result.data?['launchesPast'] ?? [];
      return launchesData
          .map((launch) => SpaceXLaunch.fromJson(launch))
          .toList();
    } catch (e) {
      throw Exception('Error fetching past launches: $e');
    }
  }

  @override
  Future<SpaceXCompany?> getCompanyInfo() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(SpaceXGraphQueries.getCompanyInfo),
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to fetch company info: ${result.exception.toString()}');
      }

      final Map<String, dynamic>? companyData = result.data?['company'];
      if (companyData == null) return null;

      return SpaceXCompany.fromJson(companyData);
    } catch (e) {
      throw Exception('Error fetching company info: $e');
    }
  }

  @override
  Stream<List<SpaceXLaunch>> watchLaunches({
    int? limit = 20,
    int? offset = 0,
  }) {
    final WatchQueryOptions options = WatchQueryOptions(
      document: gql(SpaceXGraphQueries.getAllLaunches),
      variables: {
        'limit': limit,
        'offset': offset,
      },
      pollInterval: const Duration(minutes: 5), // Poll every 5 minutes
    );

    return _client.watchQuery(options).stream.map((result) {
      if (result.hasException || result.data == null) {
        return <SpaceXLaunch>[];
      }
      final List<dynamic> launchesData = result.data?['launches'] ?? [];
      return launchesData
          .map((launch) => SpaceXLaunch.fromJson(launch))
          .toList();
    });
  }

  @override
  Stream<List<SpaceXLaunch>> watchUpcomingLaunches({int? limit = 10}) {
    final WatchQueryOptions options = WatchQueryOptions(
      document: gql(SpaceXGraphQueries.getUpcomingLaunches),
      variables: {'limit': limit},
      pollInterval: const Duration(minutes: 10), // Poll every 10 minutes
    );

    return _client.watchQuery(options).stream.map((result) {
      if (result.hasException || result.data == null) {
        return <SpaceXLaunch>[];
      }
      final List<dynamic> launchesData = result.data?['launchesUpcoming'] ?? [];
      return launchesData
          .map((launch) => SpaceXLaunch.fromJson(launch))
          .toList();
    });
  }

  @override
  void dispose() {
    // Clean up any resources if needed
  }
}
