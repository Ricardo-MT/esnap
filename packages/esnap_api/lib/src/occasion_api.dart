import 'package:esnap_api/esnap_api.dart';

/// {@template occasion_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class OccasionApi {
  /// {@macro occasion_api}
  const OccasionApi();

  /// Provides a [Stream] of all occasions.
  Stream<List<EsnapOccasion>> getOccasions();

  /// List of all translations for the occasions.
  List<EsnapOccasionTranslation> getStaticTranslations();
}

/// Error thrown when a [EsnapOccasion] with a given id is not found.
class OccasionNotFoundException implements Exception {}
