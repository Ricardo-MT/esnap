import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/models/items_view_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsOverviewFilterButton extends StatelessWidget {
  const ItemsOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((ItemsOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<ItemsViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: 'Filter',
      onSelected: (filter) {
        context
            .read<ItemsOverviewBloc>()
            .add(ItemsOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: ItemsViewFilter.all,
            child: Text('All items'),
          ),
          // PopupMenuItem(
          //   value: TodosViewFilter.activeOnly,
          //   child: Text(l10n.todosOverviewFilterActiveOnly),
          // ),
          // PopupMenuItem(
          //   value: TodosViewFilter.completedOnly,
          //   child: Text(l10n.todosOverviewFilterCompletedOnly),
          // ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
