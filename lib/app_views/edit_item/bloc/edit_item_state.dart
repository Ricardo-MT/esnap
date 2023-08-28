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
    bool isValid = false,
  }) : _isValid = isValid;

  final EditItemStatus status;
  final Item? initialItem;
  final String? imagePath;
  final EsnapColor? color;
  final EsnapClassification? classification;
  final List<EsnapOccasion> occasions;
  final bool favorite;
  final bool _isValid;

  bool get isValid => _isValid;

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
    final finalInitialItem = initialItem ?? this.initialItem;
    final finalImagePath = imagePath ?? this.imagePath;
    final finalColor = color ?? this.color;
    final finalClassification = classification ?? this.classification;
    final finalOccasions = occasions ?? this.occasions;
    final finalFavorite = favorite ?? this.favorite;
    return EditItemState(
        status: status ?? this.status,
        initialItem: finalInitialItem,
        imagePath: finalImagePath,
        color: finalColor,
        classification: finalClassification,
        occasions: finalOccasions.toList(),
        favorite: finalFavorite,
        isValid: (finalInitialItem == null ||
                finalInitialItem !=
                    finalInitialItem.copyWith(
                      imagePath: finalImagePath,
                      color: finalColor,
                      classification: finalClassification,
                      occasions: finalOccasions,
                      favorite: finalFavorite,
                    )) &&
            finalImagePath != null &&
            finalClassification != null);
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
        _isValid,
      ];
}
