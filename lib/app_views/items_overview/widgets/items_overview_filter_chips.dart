import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/models/classification_filter.dart';
import 'package:esnap/app_views/items_overview/models/color_filter.dart';
import 'package:esnap/app_views/items_overview/models/favorite_filter.dart';
import 'package:esnap/app_views/items_overview/models/occasion_filter.dart';
import 'package:esnap/app_views/translations/translations_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ItemsOverviewFilterChips extends StatelessWidget {
  const ItemsOverviewFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final translationBloc = context.watch<TranslationsBloc>();
    return BlocBuilder<ItemsOverviewBloc, ItemsOverviewState>(
      builder: (context, state) => SizedBox(
        height: 30 + spacerS.height!,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: spacerS.width!,
            ).copyWith(
              bottom: spacerS.height,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => InputChip(
              label: Builder(
                builder: (context) {
                  final filter = state.filters[index];
                  String? text = '';
                  if (filter is ClassificationFilterItem) {
                    text = translationBloc.getTranslationForClassification(
                      filter.classification,
                    );
                  } else if (filter is FavoriteFilterItem) {
                    text = l10n.favorites;
                  } else if (filter is ColorFilterItem) {
                    text = translationBloc.getTranslationForColor(
                      filter.color,
                    );
                  } else if (filter is OccasionFilterItem) {
                    text = translationBloc.getTranslationForOccasion(
                      filter.occasion,
                    );
                  }
                  return Text(text ?? '');
                },
              ),
              onDeleted: () => context.read<ItemsOverviewBloc>().add(
                    ItemsOverviewFilterChanged(state.filters[index]),
                  ),
            ),
            separatorBuilder: (_, __) => spacerS,
            itemCount: state.filters.length,
          ),
        ),
      ),
    );
  }
}
