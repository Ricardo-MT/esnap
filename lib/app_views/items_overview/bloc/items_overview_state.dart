part of 'items_overview_bloc.dart';

enum ItemsOverviewStatus { initial, loading, success, failure }

final class ItemsOverviewState extends Equatable {
  const ItemsOverviewState({
    this.status = ItemsOverviewStatus.initial,
    this.items = const [],
    this.filter = ItemsViewFilter.all,
  });

  final ItemsOverviewStatus status;
  final List<Item> items;
  final ItemsViewFilter filter;

  Iterable<Item> get filteredItems => filter.applyAll(items);

  ItemsOverviewState copyWith({
    ItemsOverviewStatus Function()? status,
    List<Item> Function()? items,
    ItemsViewFilter Function()? filter,
  }) {
    return ItemsOverviewState(
      status: status != null ? status() : this.status,
      items: items != null ? items() : this.items,
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        filter,
      ];
}
