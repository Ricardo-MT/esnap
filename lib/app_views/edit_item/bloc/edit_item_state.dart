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
    this.removingBackgroundStatus = EditItemStatus.initial,
    this.backgroundRemovedImage,
    this.isUsingOriginalImage = true,
    this.color,
    this.classification,
    this.occasions = const [],
    this.favorite = false,
    bool isValid = false,
  }) : _isValid = isValid;

  final EditItemStatus status;
  final Item? initialItem;
  final String? imagePath;
  final EditItemStatus removingBackgroundStatus;
  final Uint8List? backgroundRemovedImage;
  final bool isUsingOriginalImage;
  final EsnapColor? color;
  final EsnapClassification? classification;
  final List<EsnapOccasion> occasions;
  final bool favorite;
  final bool _isValid;

  bool get isValid => _isValid;

  bool get isNewItem => initialItem == null;

  bool get canRemoveBackground {
    if (initialItem != null) {
      return initialItem!.imagePath != imagePath ||
          !initialItem!.wasBackgroundRemoved;
    }
    return imagePath != null;
  }

  EditItemState copyWith({
    EditItemStatus? status,
    Item? initialItem,
    String? imagePath,
    EditItemStatus? removingBackgroundStatus,
    Uint8List? backgroundRemovedImage,
    bool? isUsingOriginalImage,
    EsnapColor? color,
    EsnapClassification? classification,
    List<EsnapOccasion>? occasions,
    bool? favorite,
  }) {
    final finalInitialItem = initialItem ?? this.initialItem;
    final finalImagePath = imagePath ?? this.imagePath;
    final finalRemovingBackgroundStatus =
        removingBackgroundStatus ?? this.removingBackgroundStatus;
    final finalBackgroundRemovedImage =
        backgroundRemovedImage ?? this.backgroundRemovedImage;
    final finalIsUsingOriginalImage =
        isUsingOriginalImage ?? this.isUsingOriginalImage;
    final finalColor = color ?? this.color;
    final finalClassification = classification ?? this.classification;
    final finalOccasions = occasions ?? this.occasions;
    final finalFavorite = favorite ?? this.favorite;
    return EditItemState(
      status: status ?? this.status,
      initialItem: finalInitialItem,
      imagePath: finalImagePath,
      removingBackgroundStatus: finalRemovingBackgroundStatus,
      backgroundRemovedImage: finalBackgroundRemovedImage,
      isUsingOriginalImage: finalIsUsingOriginalImage,
      color: finalColor,
      classification: finalClassification,
      occasions: finalOccasions.toList(),
      favorite: finalFavorite,
      isValid: finalRemovingBackgroundStatus != EditItemStatus.loading &&
          // If we are editing an existing item, we check if the item has been
          // modified.
          (finalInitialItem == null ||
              finalInitialItem !=
                  finalInitialItem.copyWith(
                    imagePath: finalImagePath,
                    color: finalColor,
                    classification: finalClassification,
                    occasions: finalOccasions,
                    favorite: finalFavorite,
                    // If the user is not using the original image, it means
                    // that the background has been removed.
                    wasBackgroundRemoved: !finalIsUsingOriginalImage &&
                        finalBackgroundRemovedImage != null,
                  )) &&
          // If the user is using the original image, we check if the image
          // path is not null. Otherwise, we check if the background removed
          // image is not null.
          ((finalIsUsingOriginalImage && finalImagePath != null) ||
              (!finalIsUsingOriginalImage &&
                  finalBackgroundRemovedImage != null)) &&
          finalClassification != null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialItem,
        imagePath,
        removingBackgroundStatus,
        backgroundRemovedImage,
        isUsingOriginalImage,
        color,
        classification,
        occasions,
        favorite,
        _isValid,
      ];
}
