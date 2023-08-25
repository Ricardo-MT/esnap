import 'package:esnap_api/esnap_api.dart';

/// {@template outfit_repository}
/// A repository that handles outfit related requests
/// {@endtemplate}
class OutfitRepository {
  /// {@macro outfit_repository}
  const OutfitRepository({required OutfitApi outfitApi})
      : _outfitApi = outfitApi;

  final OutfitApi _outfitApi;

  /// Provides a [Stream] of all outfits.
  Stream<List<Outfit>> getOutfits() => _outfitApi.getOutfits();

  /// Saves an [outfit].
  ///
  /// If an [outfit] with the same id already exists, it will be replaced.
  Future<void> saveOutfit(Outfit outfit) => _outfitApi.saveOutfit(outfit);

  /// Deletes the `outfit` with the given id.
  ///
  /// If no `outfit` with the given id exists, a [OutfitNotFoundException] error is
  /// thrown.
  Future<void> deleteOutfit(String id) => _outfitApi.deleteOutfit(id);
}
