import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template color}
/// A single `EsnapColor`.
///
/// Contains a [name].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [EsnapColor]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
class EsnapColor extends Equatable {
  /// {@macro color}
  EsnapColor({
    required this.name,
    required this.hexColor,
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? '$name-${const Uuid().v4()}';

  /// The unique identifier of the `EsnapColor`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `EsnapColor`'s color.
  ///
  /// Cannot be empty.
  final String name;

  /// The `EsnapColor`'s hex-color.
  ///
  /// Cannot be empty.
  final int hexColor;

  /// Returns a copy of this `EsnapColor` with the given values updated.
  ///
  /// {@macro color}
  EsnapColor copyWith({
    String? id,
    String? name,
    int? hexColor,
  }) {
    return EsnapColor(
      id: id ?? this.id,
      name: name ?? this.name,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  @override
  List<Object> get props => [id, name, hexColor];
}
