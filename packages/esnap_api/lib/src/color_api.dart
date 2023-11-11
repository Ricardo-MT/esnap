import 'package:esnap_api/esnap_api.dart';

/// {@template color_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class ColorApi {
  /// {@macro color_api}
  const ColorApi();

  /// Provides a [Stream] of all colors.
  Stream<List<EsnapColor>> getColors();

  /// List of all translations for the colors.
  List<EsnapColorTranslation> getStaticTranslations();
}

/// Error thrown when a [EsnapColor] with a given id is not found.
class ColorNotFoundException implements Exception {}
