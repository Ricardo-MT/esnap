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

  /// Provides a [Stream] of all classificationTypes.
  Stream<List<EsnapClassificationType>> getClassificationTypes() =>
      _classificationTypeApi.getClassificationTypes();
}
