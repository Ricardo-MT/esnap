import 'dart:io';

import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

class SetListTile extends StatelessWidget {
  const SetListTile({
    required this.item,
    required this.onTap,
    super.key,
  });

  final Outfit item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final items =
        [item.top, item.bottom, item.shoes].where((element) => element != null);
    final first = items.elementAtOrNull(0);
    final second = items.elementAtOrNull(1);
    final third = items.elementAtOrNull(2);
    return WidTouchable(
      onPress: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _OutfitImage(item: first),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: FractionallySizedBox(
                        heightFactor: 0.5,
                        widthFactor: 0.5,
                        child: _OutfitImage(item: second),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: FractionallySizedBox(
                        heightFactor: 0.35,
                        widthFactor: 0.35,
                        child: _OutfitImage(item: third),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _OutfitImage extends StatelessWidget {
  const _OutfitImage({
    this.item,
  });
  final Item? item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        image: item?.imagePath == null
            ? null
            : DecorationImage(
                image: FileImage(
                  File(item!.imagePath!),
                ),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

final _borderRadius =
    BorderRadius.circular(WidAppDimensions.borderRadiusControllers);
