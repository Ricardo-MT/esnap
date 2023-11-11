import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template classification_translation}
/// A single `EsnapClassificationTranslation`.
///
/// Contains a [id], [name], [classificationId] and [languageCode].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapClassificationTranslation]s are immutable and can be copied using
/// [copyWith].
/// {@endtemplate}
@immutable
class EsnapClassificationTranslation extends Equatable {
  /// {@macro classification}
  EsnapClassificationTranslation({
    required this.name,
    required this.classificationId,
    required this.languageCode,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapClassificationTranslation`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapClassification` id of the classification this translation
  /// corresponds.
  ///
  /// Cannot be empty.
  final String classificationId;

  /// The language code of this translation.
  ///
  /// Cannot be empty.
  final String languageCode;

  /// The `EsnapClassificationTranslation`'s classification.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapClassificationTranslation` with the
  /// given values updated.
  ///
  /// {@macro classification}
  EsnapClassificationTranslation copyWith({
    String? id,
    String? name,
    String? classificationId,
    String? languageCode,
  }) {
    return EsnapClassificationTranslation(
      id: id ?? this.id,
      name: name ?? this.name,
      classificationId: classificationId ?? this.classificationId,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        classificationId,
        languageCode,
      ];
}
