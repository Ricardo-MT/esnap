import 'package:esnap_api/esnap_api.dart';

/// {@template occasion_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class OccasionApi {
  /// {@macro occasion_api}
  const OccasionApi();

  /// Provides a [Stream] of all occasions.
  Stream<List<EsnapOccasion>> getOccasions();

  /// Saves a [occasion].
  ///
  /// If a [occasion] with the same id already exists, it will be replaced.
  Future<void> saveOccasion(EsnapOccasion occasion);

  /// Deletes the `occasion` with the given id.
  ///
  /// If no `occasion` with the given id exists, a [OccasionNotFoundException]
  /// error is thrown.
  Future<void> deleteOccasion(String id);
}

/// Error thrown when a [EsnapOccasion] with a given id is not found.
class OccasionNotFoundException implements Exception {}
