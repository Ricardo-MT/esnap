import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template occasion_translation}
/// A single `EsnapOccasionTranslation`.
///
/// Contains a [id], [name], [occasionId] and [languageCode].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapOccasionTranslation]s are immutable and can be copied using
/// [copyWith].
/// {@endtemplate}
@immutable
class EsnapOccasionTranslation extends Equatable {
  /// {@macro classification}
  EsnapOccasionTranslation({
    required this.name,
    required this.occasionId,
    required this.languageCode,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapOccasionTranslation`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapOccasion` id of the occasion this translation
  /// corresponds.
  ///
  /// Cannot be empty.
  final String occasionId;

  /// The language code of this translation.
  ///
  /// Cannot be empty.
  final String languageCode;

  /// The `EsnapOccasionTranslation`'s occasion.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapOccasionTranslation` with the
  /// given values updated.
  ///
  /// {@macro classification}
  EsnapOccasionTranslation copyWith({
    String? id,
    String? name,
    String? occasionId,
    String? languageCode,
  }) {
    return EsnapOccasionTranslation(
      id: id ?? this.id,
      name: name ?? this.name,
      occasionId: occasionId ?? this.occasionId,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        occasionId,
        languageCode,
      ];
}
