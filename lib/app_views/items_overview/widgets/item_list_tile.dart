import 'dart:io';

import 'package:esnap/l10n/l10n.dart';
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
    const captionColor = WidAppColors.light;
    final l10n = context.l10n;

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(WidAppDimensions.borderRadiusControllers),
      child: Hero(
        tag: item.imagePath!,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(item.imagePath!)),
              fit: BoxFit.cover,
            ),
          ),
          child: WidTouchable(
            onPress: onTap,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          WidAppColors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.55, 0.95],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            item.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: WidAppColors.light,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              item.classification?.name ?? l10n.none,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: captionColor,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.color?.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: captionColor,
                                  ),
                                ),
                                spacerXs,
                                ColorIndicator(
                                  hexColor: item.color?.hexColor ?? 0x00FFFFFF,
                                ),
                              ],
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
