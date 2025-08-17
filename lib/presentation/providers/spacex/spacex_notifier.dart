import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'spacex_state.dart';
import 'package:interesting_flutter/domain/repositories/spacex_repository_interface.dart';

/// State notifier for managing SpaceX data fetching state
class SpaceXDataNotifier extends StateNotifier<SpaceXDataState> {
  final SpaceXRepositoryInterface _repository;

  SpaceXDataNotifier(this._repository) : super(const SpaceXDataState());

  /// Refresh launches data
  Future<void> refreshLaunches({int? limit, int? offset}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final launches =
          await _repository.getLaunches(limit: limit, offset: offset);
      state = state.copyWith(
        isLoading: false,
        launches: launches,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Refresh rockets data
  Future<void> refreshRockets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final rockets = await _repository.getRockets();
      state = state.copyWith(
        isLoading: false,
        rockets: rockets,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
