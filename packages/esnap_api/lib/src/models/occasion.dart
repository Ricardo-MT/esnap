import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template occasion}
/// A single `EsnapOccasion`.
///
/// Contains a [name].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapOccasion]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
class EsnapOccasion extends Equatable {
  /// {@macro occasion}
  EsnapOccasion({
    required this.name,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapOccasion`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapOccasion`'s occasion.
  ///
  /// Cannot be empty.
  final String name;

  /// Returns a copy of this `EsnapOccasion` with the given values updated.
  ///
  /// {@macro occasion}
  EsnapOccasion copyWith({
    String? id,
    String? name,
  }) {
    return EsnapOccasion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
