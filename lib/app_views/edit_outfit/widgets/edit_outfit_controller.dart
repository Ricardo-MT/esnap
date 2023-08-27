import 'dart:io';

import 'package:esnap/app_views/classification_types_overview/bloc/classification_types_overview_bloc.dart';
import 'package:esnap/app_views/classifications_overview/bloc/classifications_overview_bloc.dart';
import 'package:esnap/app_views/edit_outfit/bloc/edit_outfit_bloc.dart';
import 'package:esnap/app_views/items_overview/bloc/items_overview_bloc.dart';
import 'package:esnap_api/esnap_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class OutfitControllers extends StatelessWidget {
  const OutfitControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ItemsField(),
        spacerS,
        _ClassificationField(),
        spacerS,
      ],
    );
  }
}

class _ItemsField extends StatelessWidget {
  const _ItemsField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOutfitBloc, EditOutfitState>(
      builder: (context, state) {
        final items = context
            .watch<ItemsOverviewBloc>()
            .state
            .items
            .where(
              (element) => _shouldDisplayItem(element, state),
            )
            .toList();
        return SizedBox(
          height: 100,
          child: items.isEmpty
              ? const Center(child: Text('no items to display'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  padding: const EdgeInsets.only(left: _chipsPadding),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: _chipsPadding),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: WidTouchable(
                          onPress: () => context
                              .read<EditOutfitBloc>()
                              .add(EditOutfitItemSubmitted(item)),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                WidAppDimensions.borderRadiusControllers,
                              ),
                              border: _isItemSelected(item, state)
                                  ? Border.all(
                                      color: WidAppColors.primary,
                                      width: 4,
                                    )
                                  : null,
                              image: DecorationImage(
                                image: FileImage(File(item.imagePath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ClassificationField extends StatelessWidget {
  const _ClassificationField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOutfitBloc, EditOutfitState>(
      builder: (context, state) {
        final classifications = context
            .watch<ClassificationsOverviewBloc>()
            .state
            .classifications
            .where((element) => element.classificationType.name == state.type)
            .toList();

        return SizedBox(
          height: _chipsHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: classifications.length,
            padding: const EdgeInsets.only(left: _chipsPadding),
            itemBuilder: (context, index) {
              final classification = classifications[index];
              return Padding(
                padding: const EdgeInsets.only(right: _chipsPadding),
                child: FilterChip(
                  label: Text(classification.name),
                  selected: state.classification?.id == classification.id,
                  onSelected: (_) => context.read<EditOutfitBloc>().add(
                        EditOutfitClassificationChanged(
                          state.classification?.id == classification.id
                              ? null
                              : classification,
                        ),
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

bool _isItemSelected(
  Item item,
  EditOutfitState state,
) {
  if (item.classification?.classificationType.name != state.type) {
    return false;
  }
  return item.id == state.top?.id ||
      item.id == state.bottom?.id ||
      item.id == state.shoes?.id;
}

bool _shouldDisplayItem(
  Item item,
  EditOutfitState state,
) {
  if (item.classification?.classificationType.name != state.type) {
    return false;
  }
  if (state.classification == null) {
    return true;
  }
  return item.classification?.id == state.classification?.id;
}

const _chipsHeight = 34.0;
const _chipsPadding = 12.0;

int _classificationTypeSorter(
  EsnapClassificationType a,
  EsnapClassificationType b,
) {
  if (a.name == 'Top') {
    return -1;
  }
  if (b.name == 'Top') {
    return 1;
  }
  if (a.name == 'Bottom') {
    return -1;
  }
  if (b.name == 'Bottom') {
    return 1;
  }
  if (a.name == 'Shoes') {
    return -1;
  }
  if (b.name == 'Shoes') {
    return 1;
  }
  return a.name.compareTo(b.name);
}
