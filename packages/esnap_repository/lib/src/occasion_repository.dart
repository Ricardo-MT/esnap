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

  /// List of all translations for the occasions.
  List<EsnapOccasionTranslation> getStaticTranslations() =>
      _occasionApi.getStaticTranslations();
}
