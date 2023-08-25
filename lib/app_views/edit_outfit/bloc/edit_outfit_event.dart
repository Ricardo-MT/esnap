part of 'edit_outfit_bloc.dart';

sealed class EditOutfitEvent extends Equatable {
  const EditOutfitEvent();

  @override
  List<Object> get props => [];
}

class EditOutfitTypeChanged extends EditOutfitEvent {
  const EditOutfitTypeChanged(this.type);
  final String type;
}

class EditOutfitClassificationChanged extends EditOutfitEvent {
  const EditOutfitClassificationChanged(this.classification);
  final EsnapClassification? classification;
}

class EditOutfitItemSubmitted extends EditOutfitEvent {
  const EditOutfitItemSubmitted(this.item);
  final Item? item;
}

class EditOutfitRemovedTop extends EditOutfitEvent {
  const EditOutfitRemovedTop();
}

class EditOutfitRemovedBottom extends EditOutfitEvent {
  const EditOutfitRemovedBottom();
}

class EditOutfitRemovedShoes extends EditOutfitEvent {
  const EditOutfitRemovedShoes();
}

class EditOutfitSubmitted extends EditOutfitEvent {
  const EditOutfitSubmitted();
}
