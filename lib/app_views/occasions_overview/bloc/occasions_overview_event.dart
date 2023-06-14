part of 'occasions_overview_bloc.dart';

sealed class OccasionsOverviewEvent extends Equatable {
  const OccasionsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class OccasionsOverviewSubscriptionRequested
    extends OccasionsOverviewEvent {
  const OccasionsOverviewSubscriptionRequested();
}
