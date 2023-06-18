part of 'items_overview_bloc.dart';

enum ItemsOverviewStatus { initial, loading, success, failure }

final class ItemsOverviewState extends Equatable {
  const ItemsOverviewState({
    this.status = ItemsOverviewStatus.initial,
    this.items = const [],
    this.filters = const [],
  });

  final ItemsOverviewStatus status;
  final List<Item> items;
  final List<Filter> filters;

  Iterable<Item> get filteredItems => items
      .where((element) => filters.every((filter) => filter.apply(element)))
      .toList();

  ItemsOverviewState copyWith({
    ItemsOverviewStatus Function()? status,
    List<Item> Function()? items,
    List<Filter> Function()? filters,
  }) {
    return ItemsOverviewState(
      status: status != null ? status() : this.status,
      items: items != null ? items() : this.items,
      filters: filters != null ? filters() : this.filters,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        filters,
      ];
}
