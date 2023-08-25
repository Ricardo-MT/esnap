import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template classification}
/// A single `EsnapClassificationType`.
///
/// Contains a [name].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapClassificationType]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
class EsnapClassificationType extends Equatable {
  /// {@macro classification}
  EsnapClassificationType({
    required this.name,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapClassificationType`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapClassificationType`'s classification.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapClassificationType` with the given values updated.
  ///
  /// {@macro classification}
  EsnapClassificationType copyWith({
    String? id,
    String? name,
  }) {
    return EsnapClassificationType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
