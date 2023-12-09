import 'dart:io';

import 'package:esnap/widgets/color_indicator.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    required this.item,
    required this.onTap,
    super.key,
  });

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(WidAppDimensions.borderRadiusControllers),
      child: Hero(
        tag: item.imagePath!,
        child: DecoratedBox(
          key: ValueKey(
            (item.imagePath ?? '') + item.wasBackgroundRemoved.toString(),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.1),
            image: DecorationImage(
              image: Image.file(
                File(item.imagePath!),
              ).image,
              fit: BoxFit.cover,
            ),
          ),
          child: WidTouchable(
            onPress: onTap,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: ColorIndicator(
                                hexColor: item.color?.hexColor ?? 0x00FFFFFF,
                              ),
                            ),
                            Icon(
                              item.favorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: WidAppColors.light,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
