import 'package:esnap_api/esnap_api.dart';

/// {@template classification_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class ClassificationTypeApi {
  /// {@macro classification_api}
  const ClassificationTypeApi();

  /// Provides a [Stream] of all classifications.
  Stream<List<EsnapClassificationType>> getClassificationTypes();

  /// List of all translations for the classifications.
  List<EsnapClassificationTypeTranslation> getStaticTranslations();
}

/// Error thrown when a [EsnapClassificationType] with a given id is not found.
class ClassificationTypeNotFoundException implements Exception {}
