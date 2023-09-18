import 'package:esnap_api/esnap_api.dart';

/// {@template occasion_repository}
/// A repository that handles occasion related requests
/// {@endtemplate}
class OccasionRepository {
  /// {@macro occasion_repository}
  const OccasionRepository({required OccasionApi occasionApi})
      : _occasionApi = occasionApi;

  final OccasionApi _occasionApi;

  /// Provides a [Stream] of all occasions.
  Stream<List<EsnapOccasion>> getOccasions() => _occasionApi.getOccasions();

  /// Saves an [occasion].
  ///
  /// If an [occasion] with the same id already exists, it will be replaced.
  Future<void> saveOccasion(EsnapOccasion occasion) =>
      _occasionApi.saveOccasion(occasion);

  /// Deletes the `occasion` with the given id.
  ///
  /// If no `occasion` with the given id exists, a [OccasionNotFoundException]
  /// error is thrown.
  Future<void> deleteOccasion(String id) => _occasionApi.deleteOccasion(id);
}
