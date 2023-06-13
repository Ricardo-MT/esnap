import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template classification}
/// A single `EsnapClassification`.
///
/// Contains a [name].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapClassification]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
class EsnapClassification extends Equatable {
  /// {@macro classification}
  EsnapClassification({
    required this.name,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the `EsnapClassification`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapClassification`'s classification.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapClassification` with the given values updated.
  ///
  /// {@macro classification}
  EsnapClassification copyWith({
    String? id,
    String? name,
  }) {
    return EsnapClassification(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
