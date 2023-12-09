import 'dart:typed_data';

import 'package:image_tools/image_tools.dart';

/// {@template image_tools_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class ImageToolsRepository {
  /// {@macro image_tools_repository}
  const ImageToolsRepository({
    required ImageTools imageTools,
  }) : _imageTools = imageTools;

  final ImageTools _imageTools;

  /// Sends image to the server and returns it with the background removed
  Future<Uint8List> removeBackground(Uint8List image) =>
      _imageTools.removeBackground(image);
}
