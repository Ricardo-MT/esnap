import 'package:esnap_api/esnap_api.dart';

/// {@template color_repository}
/// A repository that handles color related requests
/// {@endtemplate}
class ColorRepository {
  /// {@macro color_repository}
  const ColorRepository({required ColorApi colorApi}) : _colorApi = colorApi;

  final ColorApi _colorApi;

  /// Provides a [Stream] of all colors.
  Stream<List<EsnapColor>> getColors() => _colorApi.getColors();

  /// List of all translations for the colors.
  List<EsnapColorTranslation> getStaticTranslations() =>
      _colorApi.getStaticTranslations();
}
