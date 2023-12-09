import 'dart:typed_data';

/// {@template image_tools}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class ImageTools {
  /// {@macro image_tools}
  const ImageTools();

  /// Sends image to the server and returns it with the background removed
  Future<Uint8List> removeBackground(Uint8List image);
}
