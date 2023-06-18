import 'package:collection/collection.dart';
import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/models/classification_filter.dart';
import 'package:esnap/app_views/items_overview/models/color_filter.dart';
import 'package:esnap/app_views/items_overview/models/favorite_filter.dart';
import 'package:esnap/app_views/items_overview/models/occasion_filter.dart';
import 'package:esnap/app_views/items_overview/widgets/item_overview_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsOverviewFilterButton extends StatelessWidget {
  const ItemsOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final filters =
        context.select((ItemsOverviewBloc bloc) => bloc.state.filters);
    return IconButton(
      onPressed: () {
        showModalBottomSheet<ItemOverviewFilterSheet>(
          useSafeArea: true,
          context: context,
          builder: (_) => ItemOverviewFilterSheet(
            onChangeFilter: (filter) => context
                .read<ItemsOverviewBloc>()
                .add(ItemsOverviewFilterChanged(filter)),
            favorite: (filters.firstWhereOrNull(
              (element) => element.runtimeType == FavoriteFilterItem,
            ) as FavoriteFilterItem?)
                ?.favorite,
            classification: (filters.firstWhereOrNull(
              (element) => element.runtimeType == ClassificationFilterItem,
            ) as ClassificationFilterItem?)
                ?.classification,
            color: (filters.firstWhereOrNull(
              (element) => element.runtimeType == ColorFilterItem,
            ) as ColorFilterItem?)
                ?.color,
            occasion: (filters.firstWhereOrNull(
              (element) => element.runtimeType == OccasionFilterItem,
            ) as OccasionFilterItem?)
                ?.occasion,
          ),
        );
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
