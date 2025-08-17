import 'package:interesting_flutter/data/models/spacex/spacex_launch_model.dart';

class SpaceXDataState {
  final bool isLoading;
  final List<SpaceXLaunch> launches;
  final List<SpaceXRocket> rockets;
  final SpaceXCompany? company;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const SpaceXDataState({
    this.isLoading = false,
    this.launches = const [],
    this.rockets = const [],
    this.company,
    this.errorMessage,
    this.lastUpdated,
  });

  SpaceXDataState copyWith({
    bool? isLoading,
    List<SpaceXLaunch>? launches,
    List<SpaceXRocket>? rockets,
    SpaceXCompany? company,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return SpaceXDataState(
      isLoading: isLoading ?? this.isLoading,
      launches: launches ?? this.launches,
      rockets: rockets ?? this.rockets,
      company: company ?? this.company,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceXDataState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          launches == other.launches &&
          rockets == other.rockets &&
          company == other.company &&
          errorMessage == other.errorMessage &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      launches.hashCode ^
      rockets.hashCode ^
      company.hashCode ^
      errorMessage.hashCode ^
      lastUpdated.hashCode;

  @override
  String toString() {
    return 'SpaceXDataState{isLoading: $isLoading, launches: ${launches.length}, rockets: ${rockets.length}, errorMessage: $errorMessage, lastUpdated: $lastUpdated}';
  }
}

/// Parameters class for launches queries
class LaunchesParams {
  final int? limit;
  final int? offset;

  const LaunchesParams({
    this.limit = 20,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaunchesParams &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode => limit.hashCode ^ offset.hashCode;

  @override
  String toString() => 'LaunchesParams{limit: $limit, offset: $offset}';
}
