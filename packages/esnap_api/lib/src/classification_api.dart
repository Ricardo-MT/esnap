import 'package:esnap_api/esnap_api.dart';

/// {@template classification_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class ClassificationApi {
  /// {@macro classification_api}
  const ClassificationApi();

  /// The list of all classifications
  List<EsnapClassification> getStaticClassifications();

  /// Provides a [Stream] of all classifications.
  Stream<List<EsnapClassification>> getClassifications();

  /// List of all translations for the classifications.
  List<EsnapClassificationTranslation> getStaticTranslations();
}

/// Error thrown when a [EsnapClassification] with a given id is not found.
class ClassificationNotFoundException implements Exception {}
