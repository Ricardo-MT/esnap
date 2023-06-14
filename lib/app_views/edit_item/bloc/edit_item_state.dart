part of 'edit_item_bloc.dart';

enum EditItemStatus { initial, loading, success, failure }

extension EditItemStatusX on EditItemStatus {
  bool get isLoadingOrSuccess => [
        EditItemStatus.loading,
        EditItemStatus.success,
      ].contains(this);
}

final class EditItemState extends Equatable {
  const EditItemState({
    this.status = EditItemStatus.initial,
    this.initialItem,
    this.color,
    this.classification = '',
    this.occasions = const [],
  });

  final EditItemStatus status;
  final Item? initialItem;
  final EsnapColor? color;
  final String classification;
  final List<String> occasions;

  bool get isNewItem => initialItem == null;

  EditItemState copyWith({
    EditItemStatus? status,
    Item? initialItem,
    EsnapColor? color,
    String? classification,
    List<String>? occasions,
  }) {
    return EditItemState(
      status: status ?? this.status,
      initialItem: initialItem ?? this.initialItem,
      color: color ?? this.color,
      classification: classification ?? this.classification,
      occasions: (occasions ?? this.occasions).toList(),
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialItem,
        color,
        classification,
        occasions,
      ];
}
