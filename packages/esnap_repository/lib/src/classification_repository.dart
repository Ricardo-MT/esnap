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

  /// Saves an [classification].
  ///
  /// If an [classification] with the same id already exists,
  /// it will be replaced.
  Future<void> saveClassification(EsnapClassification classification) =>
      _classificationApi.saveClassification(classification);

  /// Deletes the `classification` with the given id.
  ///
  /// If no `classification` with the given id exists,
  /// a [ClassificationNotFoundException] error is thrown.
  Future<void> deleteClassification(String id) =>
      _classificationApi.deleteClassification(id);
}
