import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/colors_overview/bloc/colors_overview_bloc.dart';
import 'package:esnap/app_views/items_overview/models/classification_filter.dart';
import 'package:esnap/app_views/items_overview/models/color_filter.dart';
import 'package:esnap/app_views/items_overview/models/favorite_filter.dart';
import 'package:esnap/app_views/items_overview/models/filter.dart';
import 'package:esnap/app_views/items_overview/models/occasion_filter.dart';
import 'package:esnap/app_views/occasions_overview/bloc/occasions_overview_bloc.dart';
import 'package:esnap/app_views/translations/translations_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/widgets/color_indicator.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ItemOverviewFilterSheet extends StatefulWidget {
  const ItemOverviewFilterSheet({
    required this.onChangeFilter,
    required this.favorite,
    required this.classification,
    required this.color,
    required this.occasion,
    super.key,
  });
  final void Function(Filter filter) onChangeFilter;

  final bool? favorite;
  final EsnapClassification? classification;
  final EsnapColor? color;
  final EsnapOccasion? occasion;

  @override
  State<ItemOverviewFilterSheet> createState() =>
      _ItemOverviewFilterSheetState();
}

class _ItemOverviewFilterSheetState extends State<ItemOverviewFilterSheet> {
  late bool favorite;
  EsnapClassification? classification;
  EsnapColor? color;
  EsnapOccasion? occasion;

  @override
  void initState() {
    favorite = widget.favorite ?? false;
    classification = widget.classification;
    color = widget.color;
    occasion = widget.occasion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ColorsOverviewBloc(
            colorRepository: context.read<ColorRepository>(),
          )..add(const ColorsOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => ClassificationsOverviewBloc(
            classificationRepository: context.read<ClassificationRepository>(),
          )..add(const ClassificationsOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => OccasionsOverviewBloc(
            occasionRepository: context.read<OccasionRepository>(),
          )..add(const OccasionsOverviewSubscriptionRequested()),
        ),
      ],
      child: _ItemOverviewFilterSheet(
        selectedFavorite: favorite,
        selectedClassification: classification,
        selectedColor: color,
        selectedOccasion: occasion,
        onFavoriteChange: (bool value) {
          setState(() {
            favorite = value;
          });
          widget.onChangeFilter(FavoriteFilterItem(true));
        },
        onClassificationChange: (value) {
          setState(() {
            classification = value.id == classification?.id ? null : value;
          });
          widget.onChangeFilter(ClassificationFilterItem(value));
        },
        onColorChange: (value) {
          setState(() {
            color = value.id == color?.id ? null : value;
          });
          widget.onChangeFilter(ColorFilterItem(value));
        },
        onOccasionChange: (value) {
          setState(() {
            occasion = value.id == occasion?.id ? null : value;
          });
          widget.onChangeFilter(OccasionFilterItem(value));
        },
      ),
    );
  }
}

class _ItemOverviewFilterSheet extends StatelessWidget {
  const _ItemOverviewFilterSheet({
    required this.onFavoriteChange,
    required this.onClassificationChange,
    required this.onColorChange,
    required this.onOccasionChange,
    required this.selectedFavorite,
    required this.selectedClassification,
    required this.selectedColor,
    required this.selectedOccasion,
  });

  final void Function(bool value) onFavoriteChange;
  final void Function(EsnapClassification value) onClassificationChange;
  final void Function(EsnapColor value) onColorChange;
  final void Function(EsnapOccasion value) onOccasionChange;

  final bool selectedFavorite;
  final EsnapClassification? selectedClassification;
  final EsnapColor? selectedColor;
  final EsnapOccasion? selectedOccasion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final translationBloc = context.watch<TranslationsBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8).copyWith(top: 8),
                  child: WidText.headlineLarge(text: l10n.filters),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20,
                padding: const EdgeInsets.all(4),
                icon: const Icon(Icons.close_outlined),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: WidText.headlineSmall(text: l10n.showFavorites),
                    ),
                    Switch.adaptive(
                      value: selectedFavorite,
                      onChanged: onFavoriteChange,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const Divider(
                  color: WidAppColors.n500,
                ),
                WidText.headlineSmall(text: l10n.classificationLabel),
                Wrap(
                  spacing: 8,
                  children: context
                      .watch<ClassificationsOverviewBloc>()
                      .state
                      .classifications
                      .map(
                        (classification) => FilterChip(
                          label: Text(
                            translationBloc.getTranslationForClassification(
                              classification,
                            )!,
                          ),
                          selected:
                              classification.id == selectedClassification?.id,
                          onSelected: (_) =>
                              onClassificationChange(classification),
                        ),
                      )
                      .toList(),
                ),
                const Divider(
                  color: WidAppColors.n500,
                ),
                WidText.headlineSmall(text: l10n.colorLabel),
                Wrap(
                  spacing: 8,
                  children: context
                      .watch<ColorsOverviewBloc>()
                      .state
                      .colors
                      .map(
                        (color) => FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                translationBloc.getTranslationForColor(
                                  color,
                                )!,
                              ),
                              spacerXs,
                              ColorIndicator(hexColor: color.hexColor),
                            ],
                          ),
                          selected: color.id == selectedColor?.id,
                          onSelected: (_) => onColorChange(color),
                        ),
                      )
                      .toList(),
                ),
                const Divider(
                  color: WidAppColors.n500,
                ),
                WidText.headlineSmall(text: l10n.ocassionsLabel),
                Wrap(
                  spacing: 8,
                  children: context
                      .watch<OccasionsOverviewBloc>()
                      .state
                      .occasions
                      .map(
                        (occasion) => FilterChip(
                          label: Text(
                            translationBloc.getTranslationForOccasion(
                              occasion,
                            )!,
                          ),
                          selected: occasion.id == selectedOccasion?.id,
                          onSelected: (_) => onOccasionChange(occasion),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
