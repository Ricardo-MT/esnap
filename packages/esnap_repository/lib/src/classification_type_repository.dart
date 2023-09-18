import 'package:esnap_api/esnap_api.dart';

/// {@template classificationType_repository}
/// A repository that handles classificationType related requests
/// {@endtemplate}
class ClassificationTypeRepository {
  /// {@macro classificationType_repository}
  const ClassificationTypeRepository({
    required ClassificationTypeApi classificationTypeApi,
  }) : _classificationTypeApi = classificationTypeApi;

  final ClassificationTypeApi _classificationTypeApi;

  /// The list of all classificationTypes
  List<String> get classificationTypes =>
      _classificationTypeApi.classificationTypes;

  /// Provides a [Stream] of all classificationTypes.
  Stream<List<EsnapClassificationType>> getClassificationTypes() =>
      _classificationTypeApi.getClassificationTypes();

  /// Saves an [classificationType].
  ///
  /// If an [classificationType] with the same id already exists,
  /// it will be replaced.
  Future<void> saveClassificationType(
    EsnapClassificationType classificationType,
  ) =>
      _classificationTypeApi.saveClassificationType(classificationType);
}
