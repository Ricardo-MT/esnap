import 'dart:io';

import 'package:esnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wid_design_system/wid_design_system.dart';

class WidImagePicker extends StatelessWidget {
  const WidImagePicker({
    required this.onPicked,
    required this.imagePath,
    super.key,
  });
  final String? imagePath;
  final void Function(XFile) onPicked;

  Future<void> _handlePickImage(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final status = await Permission.camera.status;
    if (status.isPermanentlyDenied) {
      final res = await showAdaptiveDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(l10n.callToActionCamerausageTitle),
          content: Text(context.l10n.cameraUsageDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.callToActionCamerausage),
            ),
          ],
        ),
      );
      if (res == true) {
        await openAppSettings();
      }
      return;
    }
    if (status.isDenied) {
      await Permission.camera.request();
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    );
    if (pickedFile != null) {
      onPicked(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ClipRRect(
      borderRadius: _borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor,
          borderRadius: _borderRadius,
        ),
        child: WidTouchable(
          onPress:
              imagePath == null ? () => _handlePickImage(context, l10n) : () {},
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: AspectRatio(
              aspectRatio: 1,
              child: (imagePath ?? '').isNotEmpty
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            File(
                              imagePath!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 12,
                          child: ElevatedButton.icon(
                            onPressed: () => _handlePickImage(context, l10n),
                            style: ElevatedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero.copyWith(right: 2),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              size: 14,
                            ),
                            label: Text(
                              l10n.edit,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.file_upload_outlined,
                            color: WidAppColors.n600,
                          ),
                          WidText.headlineSmall(text: l10n.selectImageLabel),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

final _borderRadius = BorderRadius.all(
  Radius.circular(WidAppDimensions.borderRadiusControllers),
);
