import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template classification}
/// A single `EsnapClassificationTypeTranslation`.
///
/// Contains a [name].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapClassificationTypeTranslation]s are immutable and can be copied
/// using [copyWith].
/// {@endtemplate}
@immutable
class EsnapClassificationTypeTranslation extends Equatable {
  /// {@macro classification}
  EsnapClassificationTypeTranslation({
    required this.name,
    required this.classificationTypeId,
    required this.languageCode,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapClassificationTypeTranslation`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapClassificationTypeTranslation` id of the classification type this
  /// translation corresponds.
  ///
  /// Cannot be empty.
  final String classificationTypeId;

  /// The language code of this translation.
  ///
  /// Cannot be empty.
  final String languageCode;

  /// The `EsnapClassificationTypeTranslation`'s classification.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapClassificationTypeTranslation` with the given
  /// values updated.
  ///
  /// {@macro classification}
  EsnapClassificationTypeTranslation copyWith({
    String? id,
    String? name,
    String? classificationTypeId,
    String? languageCode,
  }) {
    return EsnapClassificationTypeTranslation(
      id: id ?? this.id,
      name: name ?? this.name,
      classificationTypeId: classificationTypeId ?? this.classificationTypeId,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        classificationTypeId,
        languageCode,
      ];
}
