part of 'sets_overview_bloc.dart';

enum SetsOverviewStatus { initial, loading, success, failure }

final class SetsOverviewState extends Equatable {
  const SetsOverviewState({
    this.status = SetsOverviewStatus.initial,
    this.items = const [],
  });

  final SetsOverviewStatus status;
  final List<Outfit> items;

  Iterable<Outfit> get filteredSets => items.toList();

  SetsOverviewState copyWith({
    SetsOverviewStatus Function()? status,
    List<Outfit> Function()? items,
  }) {
    return SetsOverviewState(
      status: status != null ? status() : this.status,
      items: items != null ? items() : this.items,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
      ];
}
