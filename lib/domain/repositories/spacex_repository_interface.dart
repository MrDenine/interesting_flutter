import 'package:interesting_flutter/data/models/spacex/spacex_company_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_rocket_model.dart';

import '../../data/models/spacex/spacex_launch_model.dart';

/// Abstract repository interface for SpaceX data operations
/// This defines the contract that any SpaceX data source must implement
abstract class SpaceXRepositoryInterface {
  /// Fetch all launches with pagination
  Future<List<SpaceXLaunch>> getLaunches({
    int? limit,
    int? offset,
  });

  /// Fetch launch by ID
  Future<SpaceXLaunch?> getLaunchById(String id);

  /// Fetch all rockets
  Future<List<SpaceXRocket>> getRockets();

  /// Fetch rocket by ID
  Future<SpaceXRocket?> getRocketById(String id);

  /// Fetch upcoming launches
  Future<List<SpaceXLaunch>> getUpcomingLaunches({int? limit});

  /// Fetch past launches
  Future<List<SpaceXLaunch>> getPastLaunches({
    int? limit,
    int? offset,
  });

  /// Fetch company information
  Future<SpaceXCompany?> getCompanyInfo();

  /// Stream for watching launches (useful for real-time updates)
  Stream<List<SpaceXLaunch>> watchLaunches({
    int? limit,
    int? offset,
  });

  /// Stream for watching upcoming launches
  Stream<List<SpaceXLaunch>> watchUpcomingLaunches({int? limit});

  /// Dispose resources
  void dispose();
}
