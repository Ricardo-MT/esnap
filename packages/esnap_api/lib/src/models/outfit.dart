import 'package:equatable/equatable.dart';
import 'package:esnap_api/esnap_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

// part 'outfit.g.dart';

/// {@template outfit}
/// A single `outfit`.
///
/// Contains a [top], [bottom] and [shoes].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Outfit]s are immutable and can be copied using [copyWith].
/// {@endtemplate}
@immutable
@JsonSerializable()
class Outfit extends Equatable {
  /// {@macro outfit}
  Outfit({
    String? id,
    this.bottom,
    this.top,
    this.shoes,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the `outfit`.
  ///
  /// Cannot be empty.
  final String id;

  /// The `outfit`'s top.
  final Item? top;

  /// The `outfit`'s bottom.
  final Item? bottom;

  /// A list of the `outfit`'s shoes.
  ///
  /// Defaults to an empty list.
  final Item? shoes;

  /// Returns a copy of this `outfit` with the given values updated.
  ///
  /// {@macro outfit}
  Outfit copyWith({
    String? id,
    Item? top,
    Item? bottom,
    Item? shoes,
  }) {
    return Outfit(
      id: id ?? this.id,
      top: (top ?? this.top)?.copyWith(),
      bottom: (bottom ?? this.bottom)?.copyWith(),
      shoes: (shoes ?? this.shoes)?.copyWith(),
    );
  }

  @override
  String toString() {
    var res = '';
    final a = _nameFromItem(top);
    final b = _nameFromItem(bottom);
    final c = _nameFromItem(shoes);

    res = [a, b, c].where((element) => element.isNotEmpty).join(', ');

    res = res.toLowerCase();
    return res.isEmpty
        ? '(no name)'
        : '${res[0].toUpperCase()}${res.substring(1)}';
  }

  @override
  List<Object?> get props => [
        id,
        top,
        bottom,
        shoes,
      ];
}

String _nameFromItem(Item? item) {
  var a = item?.color?.name ?? '';
  if (item?.classification != null) {
    a += '${a.isEmpty ? '' : ' '}${item?.classification?.name ?? ''}';
  } else {
    a = '';
  }
  return a;
}
