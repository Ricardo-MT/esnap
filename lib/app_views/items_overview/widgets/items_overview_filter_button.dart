import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/models/classification_filter.dart';
import 'package:esnap/app_views/items_overview/models/color_filter.dart';
import 'package:esnap/app_views/items_overview/models/favorite_filter.dart';
import 'package:esnap/app_views/items_overview/models/filter.dart';
import 'package:esnap/app_views/items_overview/models/occasion_filter.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsOverviewFilterButton extends StatelessWidget {
  const ItemsOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Filter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: 'Filter',
      onSelected: (filter) {
        context
            .read<ItemsOverviewBloc>()
            .add(ItemsOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ColorFilterItem(
              EsnapColor(
                id: 'Beige-f3551b3b-5b4e-45a4-9615-415067455b37',
                name: '',
                hexColor: 56,
              ),
            ),
            child: const Text('Beige'),
          ),
          PopupMenuItem(
            value: FavoriteFilterItem(true),
            child: const Text('Favorites'),
          ),
          PopupMenuItem(
            value: ClassificationFilterItem(
              EsnapClassification(
                name: 'asd',
                id: 'Accessory-3e046ac0-16a0-4555-b302-21b2328b600f',
              ),
            ),
            child: const Text('Accessory'),
          ),
          PopupMenuItem(
            value: OccasionFilterItem(
              EsnapOccasion(
                name: 'asd',
                id: 'Afternoon tea-f178573e-83fa-4995-9fe1-c413b987cd09',
              ),
            ),
            child: const Text('Afternoon'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
