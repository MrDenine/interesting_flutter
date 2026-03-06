import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interesting_flutter/data/data_sources/spacex_graphql_data_source.dart';
import 'package:interesting_flutter/data/data_sources/spacex_data_source_interface.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_company_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_launch_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_rocket_model.dart';
import 'spacex_state.dart';

/// Provider for SpaceX data source (GraphQL implementation)
final spaceXDataSourceProvider = Provider<SpaceXDataSourceInterface>((ref) {
  return SpaceXGraphQLDataSource();
});

/// Provider for all launches
final launchesProvider = FutureProvider.autoDispose
    .family<List<SpaceXLaunch>, LaunchesParams>((ref, params) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getLaunches(
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for launch by ID
final launchByIdProvider =
    FutureProvider.family<SpaceXLaunch?, String>((ref, id) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getLaunchById(id);
});

/// Provider for all rockets
final rocketsProvider = FutureProvider<List<SpaceXRocket>>((ref) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getRockets();
});

/// Provider for rocket by ID
final rocketByIdProvider =
    FutureProvider.family<SpaceXRocket?, String>((ref, id) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getRocketById(id);
});

/// Provider for upcoming launches
final upcomingLaunchesProvider =
    FutureProvider.family<List<SpaceXLaunch>, int>((ref, limit) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getUpcomingLaunches(limit: limit);
});

/// Provider for past launches
final pastLaunchesProvider =
    FutureProvider.family<List<SpaceXLaunch>, LaunchesParams>(
        (ref, params) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getPastLaunches(
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for company information
final companyInfoProvider = FutureProvider<SpaceXCompany?>((ref) async {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.getCompanyInfo();
});

/// Provider for watching launches (stream)
final launchesStreamProvider =
    StreamProvider.family<List<SpaceXLaunch>, LaunchesParams>((ref, params) {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.watchLaunches(
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for watching upcoming launches (stream)
final upcomingLaunchesStreamProvider =
    StreamProvider.family<List<SpaceXLaunch>, int>((ref, limit) {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return dataSource.watchUpcomingLaunches(limit: limit);
});
