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
    this.imagePath,
    this.color,
    this.classification,
    this.occasions = const [],
    this.favorite = false,
  });

  final EditItemStatus status;
  final Item? initialItem;
  final String? imagePath;
  final EsnapColor? color;
  final EsnapClassification? classification;
  final List<EsnapOccasion> occasions;
  final bool favorite;

  bool get isNewItem => initialItem == null;

  EditItemState copyWith({
    EditItemStatus? status,
    Item? initialItem,
    String? imagePath,
    EsnapColor? color,
    EsnapClassification? classification,
    List<EsnapOccasion>? occasions,
    bool? favorite,
  }) {
    return EditItemState(
      status: status ?? this.status,
      initialItem: initialItem ?? this.initialItem,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      classification: classification ?? this.classification,
      occasions: (occasions ?? this.occasions).toList(),
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialItem,
        imagePath,
        color,
        classification,
        occasions,
        favorite,
      ];
}
