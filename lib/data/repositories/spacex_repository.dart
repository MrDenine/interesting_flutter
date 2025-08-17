import '../../domain/repositories/spacex_repository_interface.dart';
import '../datasources/spacex_datasource_interface.dart';
import '../models/spacex/spacex_launch_model.dart';

/// Repository implementation for SpaceX data operations
/// This coordinates between domain and data source layers
class SpaceXRepository implements SpaceXRepositoryInterface {
  final SpaceXDataSourceInterface _dataSource;

  SpaceXRepository(this._dataSource);

  @override
  Future<List<SpaceXLaunch>> getLaunches({
    int? limit,
    int? offset,
  }) {
    return _dataSource.getLaunches(limit: limit, offset: offset);
  }

  @override
  Future<SpaceXLaunch?> getLaunchById(String id) {
    return _dataSource.getLaunchById(id);
  }

  @override
  Future<List<SpaceXRocket>> getRockets() {
    return _dataSource.getRockets();
  }

  @override
  Future<SpaceXRocket?> getRocketById(String id) {
    return _dataSource.getRocketById(id);
  }

  @override
  Future<List<SpaceXLaunch>> getUpcomingLaunches({int? limit}) {
    return _dataSource.getUpcomingLaunches(limit: limit);
  }

  @override
  Future<List<SpaceXLaunch>> getPastLaunches({
    int? limit,
    int? offset,
  }) {
    return _dataSource.getPastLaunches(limit: limit, offset: offset);
  }

  @override
  Future<SpaceXCompany?> getCompanyInfo() {
    return _dataSource.getCompanyInfo();
  }

  @override
  Stream<List<SpaceXLaunch>> watchLaunches({
    int? limit,
    int? offset,
  }) {
    return _dataSource.watchLaunches(limit: limit, offset: offset);
  }

  @override
  Stream<List<SpaceXLaunch>> watchUpcomingLaunches({int? limit}) {
    return _dataSource.watchUpcomingLaunches(limit: limit);
  }

  @override
  void dispose() {
    _dataSource.dispose();
  }
}
