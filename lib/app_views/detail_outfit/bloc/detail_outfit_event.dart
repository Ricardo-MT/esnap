part of 'detail_outfit_bloc.dart';

sealed class DetailOutfitEvent extends Equatable {
  const DetailOutfitEvent();

  @override
  List<Object?> get props => [];
}

final class DetailOutfitDeleteSubmitted extends DetailOutfitEvent {
  const DetailOutfitDeleteSubmitted();

  @override
  List<Object?> get props => [];
}
