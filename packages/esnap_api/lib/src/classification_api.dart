import 'package:esnap_api/esnap_api.dart';

/// {@template classification_api}
/// The interface and models for an API providing access to clothing items.
/// {@endtemplate}
abstract class ClassificationApi {
  /// {@macro classification_api}
  const ClassificationApi();

  /// Provides a [Stream] of all classifications.
  Stream<List<EsnapClassification>> getClassifications();

  /// Saves a [classification].
  ///
  /// If a [classification] with the same id already exists, it will be replaced.
  Future<void> saveClassification(EsnapClassification classification);

  /// Deletes the `classification` with the given id.
  ///
  /// If no `classification` with the given id exists, a
  /// [ClassificationNotFoundException] error is thrown.
  Future<void> deleteClassification(String id);
}

/// Error thrown when a [EsnapClassification] with a given id is not found.
class ClassificationNotFoundException implements Exception {}
