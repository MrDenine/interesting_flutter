import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interesting_flutter/data/datasources/spacex_graphql_datasource.dart';
import 'package:interesting_flutter/data/datasources/spacex_datasource_interface.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_company_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_launch_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_rocket_model.dart';
import 'package:interesting_flutter/data/repositories/spacex_repository.dart';
import 'package:interesting_flutter/domain/repositories/spacex_repository_interface.dart';
import 'spacex_state.dart';

/// Provider for SpaceX data source (GraphQL implementation)
final spaceXDataSourceProvider = Provider<SpaceXDataSourceInterface>((ref) {
  return SpaceXGraphQLDataSource();
});

/// Provider for SpaceX repository (abstraction layer)
final spaceXRepositoryProvider = Provider<SpaceXRepositoryInterface>((ref) {
  final dataSource = ref.read(spaceXDataSourceProvider);
  return SpaceXRepository(dataSource);
});

/// Provider for all launches
final launchesProvider = FutureProvider.autoDispose
    .family<List<SpaceXLaunch>, LaunchesParams>((ref, params) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getLaunches(
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for launch by ID
final launchByIdProvider =
    FutureProvider.family<SpaceXLaunch?, String>((ref, id) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getLaunchById(id);
});

/// Provider for all rockets
final rocketsProvider = FutureProvider<List<SpaceXRocket>>((ref) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getRockets();
});

/// Provider for rocket by ID
final rocketByIdProvider =
    FutureProvider.family<SpaceXRocket?, String>((ref, id) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getRocketById(id);
});

/// Provider for upcoming launches
final upcomingLaunchesProvider =
    FutureProvider.family<List<SpaceXLaunch>, int>((ref, limit) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getUpcomingLaunches(limit: limit);
});

/// Provider for past launches
final pastLaunchesProvider =
    FutureProvider.family<List<SpaceXLaunch>, LaunchesParams>(
        (ref, params) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getPastLaunches(
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for company information
final companyInfoProvider = FutureProvider<SpaceXCompany?>((ref) async {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.getCompanyInfo();
});

/// Provider for watching launches (stream)
final launchesStreamProvider =
    StreamProvider.family<List<SpaceXLaunch>, LaunchesParams>((ref, params) {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.watchLaunches(
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for watching upcoming launches (stream)
final upcomingLaunchesStreamProvider =
    StreamProvider.family<List<SpaceXLaunch>, int>((ref, limit) {
  final repository = ref.read(spaceXRepositoryProvider);
  return repository.watchUpcomingLaunches(limit: limit);
});
