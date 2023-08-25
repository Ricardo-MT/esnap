part of 'classification_types_overview_bloc.dart';

sealed class ClassificationTypesOverviewEvent extends Equatable {
  const ClassificationTypesOverviewEvent();

  @override
  List<Object> get props => [];
}

final class ClassificationTypesOverviewSubscriptionRequested
    extends ClassificationTypesOverviewEvent {
  const ClassificationTypesOverviewSubscriptionRequested();
}
