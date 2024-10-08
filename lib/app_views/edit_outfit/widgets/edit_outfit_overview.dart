import 'dart:io';

import 'package:esnap/app_views/edit_outfit/bloc/edit_outfit_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class OutfitOverview extends StatelessWidget {
  const OutfitOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        spacerXs,
        Expanded(
          flex: 4,
          child: _ItemDisplay(
            label: l10n.top,
            type: 'Top',
          ),
        ),
        spacerXs,
        Expanded(
          flex: 4,
          child: _ItemDisplay(
            label: l10n.bottom,
            type: 'Bottom',
          ),
        ),
        spacerXs,
        Expanded(
          flex: 3,
          child: _ItemDisplay(
            label: l10n.shoes,
            type: 'Shoes',
          ),
        ),
      ],
    );
  }
}

class _ItemDisplay extends StatelessWidget {
  const _ItemDisplay({
    required this.label,
    required this.type,
  });
  final String label;
  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOutfitBloc, EditOutfitState>(
      buildWhen: (previous, current) {
        final changedType = previous.type == type || current.type == type;
        if (type == 'Top') {
          return previous.top != current.top || changedType;
        } else if (type == 'Bottom') {
          return previous.bottom != current.bottom || changedType;
        } else if (type == 'Shoes') {
          return previous.shoes != current.shoes || changedType;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        final item = type == 'Top'
            ? state.top
            : type == 'Bottom'
                ? state.bottom
                : state.shoes;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Visibility.maintain(
              visible: false,
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.remove_circle),
              ),
            ),
            WidTouchable(
              onPress: () => context.read<EditOutfitBloc>().add(
                    EditOutfitTypeChanged(type),
                  ),
              child: AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: item != null
                        ? null
                        : Theme.of(context).brightness == Brightness.dark
                            ? WidAppColors.n600
                            : WidAppColors.n300,
                    image: item == null
                        ? null
                        : DecorationImage(
                            image: FileImage(File(item.imagePath!)),
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.circular(
                      WidAppDimensions.borderRadiusControllers,
                    ),
                    border: Border.all(
                      color: type == state.type
                          ? WidAppColors.primary
                          : Colors.transparent,
                      width: 4,
                    ),
                  ),
                  child: Visibility(
                    visible: item == null,
                    child: Center(
                      child: WidText.headlineMedium(
                        text: label,
                        style: const TextStyle(color: WidAppColors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility.maintain(
              visible: item != null,
              child: IconButton(
                onPressed: item != null
                    ? () {
                        final blocProvider = context.read<EditOutfitBloc>();
                        if (type == 'Top') {
                          blocProvider.add(const EditOutfitRemovedTop());
                          return;
                        }
                        if (type == 'Bottom') {
                          blocProvider.add(const EditOutfitRemovedBottom());
                          return;
                        }
                        if (type == 'Shoes') {
                          blocProvider.add(const EditOutfitRemovedShoes());
                          return;
                        }
                      }
                    : null,
                icon: const Icon(Icons.remove_circle),
              ),
            ),
          ],
        );
      },
    );
  }
}
