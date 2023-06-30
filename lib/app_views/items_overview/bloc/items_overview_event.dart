part of 'items_overview_bloc.dart';

sealed class ItemsOverviewEvent extends Equatable {
  const ItemsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class ItemsOverviewSubscriptionRequested extends ItemsOverviewEvent {
  const ItemsOverviewSubscriptionRequested();
}

class ItemsOverviewFilterChanged extends ItemsOverviewEvent {
  const ItemsOverviewFilterChanged(this.filter);

  final Filter filter;

  @override
  List<Filter> get props => [filter];
}

class ItemsOverviewQuickFilterChanged extends ItemsOverviewEvent {
  const ItemsOverviewQuickFilterChanged(this.filter);

  final Filter filter;

  @override
  List<Filter> get props => [filter];
}
