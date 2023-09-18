import 'package:esnap_api/esnap_api.dart';

/// {@template classification_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class ClassificationTypeApi {
  /// {@macro classification_api}
  const ClassificationTypeApi();

  /// The list of all classifications
  List<String> get classificationTypes;

  /// Provides a [Stream] of all classifications.
  Stream<List<EsnapClassificationType>> getClassificationTypes();

  /// Saves a [classification].
  ///
  /// If a [classification] with the same id already exists,
  /// it will be replaced.
  Future<void> saveClassificationType(EsnapClassificationType classification);
}

/// Error thrown when a [EsnapClassificationType] with a given id is not found.
class ClassificationTypeNotFoundException implements Exception {}
