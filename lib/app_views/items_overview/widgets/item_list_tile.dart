import 'dart:io';

import 'package:esnap/app_views/translations/translations_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/widgets/color_indicator.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final translationBloc = context.watch<TranslationsBloc>();

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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          translationBloc.getTranslationForClassification(
                                item.classification,
                              ) ??
                              l10n.none,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: captionColor,
                          ),
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
