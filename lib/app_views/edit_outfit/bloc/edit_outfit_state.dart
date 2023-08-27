part of 'edit_outfit_bloc.dart';

enum EditOutfitStatus { initial, loading, success, failure }

extension EditOutfitStatusX on EditOutfitStatus {
  bool get isLoadingOrSuccess => [
        EditOutfitStatus.loading,
        EditOutfitStatus.success,
      ].contains(this);
}

final class EditOutfitState extends Equatable {
  const EditOutfitState({
    required this.type,
    this.classification,
    this.status = EditOutfitStatus.initial,
    this.initialOutfit,
    this.top,
    this.bottom,
    this.shoes,
    bool isValid = false,
  }) : _isValid = isValid;

  final EditOutfitStatus status;
  final Outfit? initialOutfit;
  final Item? top;
  final Item? bottom;
  final Item? shoes;
  final String type;
  final EsnapClassification? classification;
  final bool _isValid;

  bool get isValid => _isValid;

  bool get isNewOutfit => initialOutfit == null;

  EditOutfitState copyWith({
    EditOutfitStatus? status,
    String? type,
    EsnapClassification? classification,
    bool forceClassification = false,
    Outfit? initialOutfit,
    Item? top,
    bool forceTop = false,
    Item? bottom,
    bool forceBottom = false,
    Item? shoes,
    bool forceShoes = false,
  }) {
    final finalClassification = forceClassification
        ? classification
        : classification ?? this.classification;

    final finalTop = forceTop ? top : top ?? this.top;
    final finalBottom = forceBottom ? bottom : bottom ?? this.bottom;
    final finalShoes = forceShoes ? shoes : shoes ?? this.shoes;
    final finalOutfit = initialOutfit ?? this.initialOutfit;

    return EditOutfitState(
      status: status ?? this.status,
      type: type ?? this.type,
      initialOutfit: finalOutfit,
      classification: finalClassification,
      top: finalTop,
      bottom: finalBottom,
      shoes: finalShoes,
      isValid: (finalOutfit == null ||
                  finalOutfit !=
                      finalOutfit.copyWith(
                        top: finalTop,
                        bottom: finalBottom,
                        shoes: finalShoes,
                      )) &&
              finalTop != null ||
          finalBottom != null ||
          finalShoes != null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        type,
        classification,
        initialOutfit,
        top,
        bottom,
        shoes,
      ];
}
