import 'package:esnap_api/esnap_api.dart';

/// {@template classification_repository}
/// A repository that handles classification related requests
/// {@endtemplate}
class ClassificationRepository {
  /// {@macro classification_repository}
  const ClassificationRepository({required ClassificationApi classificationApi})
      : _classificationApi = classificationApi;

  final ClassificationApi _classificationApi;

  /// The list of all classifications
  List<EsnapClassification> getStaticClassifications() =>
      _classificationApi.getStaticClassifications();

  /// Provides a [Stream] of all classifications.
  Stream<List<EsnapClassification>> getClassifications() =>
      _classificationApi.getClassifications();

  /// List of all translations for the classifications.
  List<EsnapClassificationTranslation> getStaticTranslations() =>
      _classificationApi.getStaticTranslations();
}
