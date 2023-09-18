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

  /// Saves an [color].
  ///
  /// If an [color] with the same id already exists, it will be replaced.
  Future<void> saveColor(EsnapColor color) => _colorApi.saveColor(color);

  /// Deletes the `color` with the given id.
  ///
  /// If no `color` with the given id exists, a [ColorNotFoundException]
  /// error is thrown.
  Future<void> deleteColor(String id) => _colorApi.deleteColor(id);
}
