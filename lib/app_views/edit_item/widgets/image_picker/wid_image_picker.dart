import 'dart:io';

import 'package:esnap/app_views/edit_item/widgets/image_picker/bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wid_design_system/wid_design_system.dart';

class WidImagePicker extends StatelessWidget {
  const WidImagePicker({
    required this.imageFile,
    required this.imageBytes,
    required this.isFromFile,
    required this.onPicked,
    super.key,
  });
  final File? imageFile;
  final Uint8List? imageBytes;
  final bool isFromFile;
  final void Function(XFile) onPicked;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImagePickerBloc>(
      create: (context) => ImagePickerBloc(),
      child: _WidImagePicker(
        onPicked: onPicked,
        imageFile: imageFile,
        imageBytes: imageBytes,
        isFromFile: isFromFile,
      ),
    );
  }
}

class _WidImagePicker extends StatelessWidget {
  const _WidImagePicker({
    required this.onPicked,
    required this.imageFile,
    required this.imageBytes,
    required this.isFromFile,
  });
  final File? imageFile;
  final Uint8List? imageBytes;
  final bool isFromFile;
  final void Function(XFile) onPicked;

  Future<void> _handleCameraPermissions(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (Platform.isAndroid) {
      return;
    }
    final status = await Permission.camera.status;
    // if (!status.isGranted) {
    //   status = await Permission.camera.request();
    // }
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
              child: Text(l10n.callToActionOpenSettings),
            ),
          ],
        ),
      );
      if (res == true) {
        await openAppSettings();
      }
    }
  }

  Future<void> _handleGalleryPermissions(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (Platform.isAndroid) {
      return;
    }
    final status = await Permission.photos.status;
    // if (!status.isGranted) {
    //   status = await Permission.photos.request();
    // }
    if (status.isPermanentlyDenied) {
      final res = await showAdaptiveDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(l10n.callToActionGalleryusageTitle),
          content: Text(context.l10n.galleryUsageDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.callToActionOpenSettings),
            ),
          ],
        ),
      );
      if (res == true) {
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<ImagePickerBloc, ImagePickerState>(
          listenWhen: (previous, current) => previous.source != current.source,
          listener: (context, state) async {
            if (state.source != null) {
              final bloc = context.read<ImagePickerBloc>();
              final l10n = context.l10n;
              if (state.source == ImageSource.camera) {
                await _handleCameraPermissions(context, l10n);
              }
              if (state.source == ImageSource.gallery) {
                await _handleGalleryPermissions(context, l10n);
              }
              final pickedFile = await ImagePicker().pickImage(
                source: state.source!,
              );
              if (pickedFile != null) {
                onPicked(pickedFile);
              }
              bloc.add(const ImagePickerReset());
            }
          },
        ),
        BlocListener<ImagePickerBloc, ImagePickerState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (imagePickerContext, state) async {
            if (state.status == ImagePickerStatus.askingSource) {
              final bloc = imagePickerContext.read<ImagePickerBloc>();
              final res = await showAdaptiveDialog<ImageSource?>(
                context: context,
                builder: (context) => AlertDialog.adaptive(
                  title: Text(l10n.selectImageSourceTitle),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        trailing: const Icon(Icons.camera_alt_outlined),
                        title: Text(
                          l10n.imageSourceCamera,
                        ),
                        onTap: () =>
                            Navigator.of(context).pop(ImageSource.camera),
                      ),
                      ListTile(
                        trailing: const Icon(Icons.photo_library_outlined),
                        title: Text(
                          l10n.imageSourceGallery,
                        ),
                        onTap: () =>
                            Navigator.of(context).pop(ImageSource.gallery),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              );
              if (res != null) {
                bloc.add(
                  ImagePickerSourceSelected(res),
                );
              } else {
                bloc.add(
                  const ImagePickerReset(),
                );
              }
            }
          },
        ),
      ],
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).splashColor,
            borderRadius: _borderRadius,
          ),
          child: WidTouchable(
            onPress: imageFile == null
                ? () => context.read<ImagePickerBloc>().add(
                      const ImagePickerSourceAsked(),
                    )
                : () {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: AspectRatio(
                aspectRatio: 1,
                child: (imageFile != null || imageBytes != null)
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: isFromFile
                                ? Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    imageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 5,
                            left: 12,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: WidAppColors.n900.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    context.read<ImagePickerBloc>().add(
                                          const ImagePickerSourceAsked(),
                                        ),
                                color: WidAppColors.n100,
                                iconSize: 24,
                                icon: const Icon(Icons.image_search_rounded),
                                style: ElevatedButton.styleFrom(
                                  visualDensity: VisualDensity.standard,
                                  padding: EdgeInsets.zero,
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
                            WidText.headlineSmall(
                              text: l10n.selectImageLabel,
                            ),
                          ],
                        ),
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
