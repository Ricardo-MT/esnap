part of 'sets_overview_bloc.dart';

sealed class SetsOverviewEvent extends Equatable {
  const SetsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class SetsOverviewSubscriptionRequested extends SetsOverviewEvent {
  const SetsOverviewSubscriptionRequested();
}
