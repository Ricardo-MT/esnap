part of 'colors_overview_bloc.dart';

sealed class ColorsOverviewEvent extends Equatable {
  const ColorsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class ColorsOverviewSubscriptionRequested extends ColorsOverviewEvent {
  const ColorsOverviewSubscriptionRequested();
}
