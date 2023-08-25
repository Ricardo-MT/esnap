import 'package:esnap_api/esnap_api.dart';

/// {@template esnap_api}
/// The interface and models for an API providing access to clothing outfits.
/// {@endtemplate}
abstract class OutfitApi {
  /// {@macro esnap_api}
  const OutfitApi();

  /// Provides a [Stream] of all todos.
  Stream<List<Outfit>> getOutfits();

  /// Saves an [outfit].
  ///
  /// If an [outfit] with the same id already exists, it will be replaced.
  Future<void> saveOutfit(Outfit outfit);

  /// Deletes the `outfit` with the given id.
  ///
  /// If no `outfit` with the given id exists, a [OutfitNotFoundException] error is
  /// thrown.
  Future<void> deleteOutfit(String id);
}

/// Error thrown when a [Outfit] with a given id is not found.
class OutfitNotFoundException implements Exception {}
