import 'package:esnap_api/esnap_api.dart';

/// {@template color_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class ColorApi {
  /// {@macro color_api}
  const ColorApi();

  /// Provides a [Stream] of all colors.
  Stream<List<EsnapColor>> getColors();

  /// Saves a [color].
  ///
  /// If a [color] with the same id already exists, it will be replaced.
  Future<void> saveColor(EsnapColor color);

  /// Deletes the `color` with the given id.
  ///
  /// If no `color` with the given id exists, a [ColorNotFoundException] error
  /// is thrown.
  Future<void> deleteColor(String id);
}

/// Error thrown when a [EsnapColor] with a given id is not found.
class ColorNotFoundException implements Exception {}
