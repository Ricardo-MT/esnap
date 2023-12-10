import 'dart:io';

import 'package:collection/collection.dart';
import 'package:esnap/utils/get_translated_name.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

class SetListTile extends StatelessWidget {
  const SetListTile({
    required this.tileHeight,
    required this.item,
    required this.onTap,
    super.key,
  });

  final double tileHeight;
  final Outfit item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final items =
        [item.top, item.bottom, item.shoes].where((element) => element != null);
    final middleIndex = (items.length / 2).ceil() - 1;
    return WidTouchable(
      onPress: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: tileHeight - 32,
            child: Column(
              children: items
                  .mapIndexed(
                    (index, element) => Expanded(
                      flex: index <= middleIndex ? 4 : 3,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _OutfitImage(item: element),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 32,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  getTranslatedNameFromOutfit(context, item),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitImage extends StatelessWidget {
  const _OutfitImage({
    // ignore: unused_element
    this.item,
  });
  final Item? item;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
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
      ),
    );
  }
}

final _borderRadius =
    BorderRadius.circular(WidAppDimensions.borderRadiusControllers);
