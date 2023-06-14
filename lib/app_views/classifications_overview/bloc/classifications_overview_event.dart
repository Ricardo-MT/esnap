part of 'classifications_overview_bloc.dart';

sealed class ClassificationsOverviewEvent extends Equatable {
  const ClassificationsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class ClassificationsOverviewSubscriptionRequested
    extends ClassificationsOverviewEvent {
  const ClassificationsOverviewSubscriptionRequested();
}
