import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template color_translation}
/// A single `EsnapColorTranslation`.
///
/// Contains a [id], [name], [colorId] and [languageCode].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapColorTranslation]s are immutable and can be copied using
/// [copyWith].
/// {@endtemplate}
@immutable
class EsnapColorTranslation extends Equatable {
  /// {@macro classification}
  EsnapColorTranslation({
    required this.name,
    required this.colorId,
    required this.languageCode,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapColorTranslation`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapColor` id of the color this translation
  /// corresponds.
  ///
  /// Cannot be empty.
  final String colorId;

  /// The language code of this translation.
  ///
  /// Cannot be empty.
  final String languageCode;

  /// The `EsnapColorTranslation`'s color.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapColorTranslation` with the
  /// given values updated.
  ///
  /// {@macro classification}
  EsnapColorTranslation copyWith({
    String? id,
    String? name,
    String? colorId,
    String? languageCode,
  }) {
    return EsnapColorTranslation(
      id: id ?? this.id,
      name: name ?? this.name,
      colorId: colorId ?? this.colorId,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        colorId,
        languageCode,
      ];
}
