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
    return WidTouchable(
      onPress: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(WidAppDimensions.borderRadiusControllers),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: item.top == null
                          ? null
                          : DecorationImage(
                              image: FileImage(File(item.top!.imagePath!)),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: FractionallySizedBox(
                        heightFactor: 0.5,
                        widthFactor: 0.5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: item.bottom == null
                                ? null
                                : DecorationImage(
                                    image: FileImage(
                                      File(item.bottom!.imagePath!),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
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
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: item.shoes == null
                                ? null
                                : DecorationImage(
                                    image:
                                        FileImage(File(item.shoes!.imagePath!)),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const WidText.bodyMedium(
            text: 'Blusa blanca, vaqueros azules y tacones',
          )
        ],
      ),
    );
  }
}
