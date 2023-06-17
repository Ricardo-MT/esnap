part of 'edit_item_bloc.dart';

sealed class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object?> get props => [];
}

final class EditItemImagePathChanged extends EditItemEvent {
  const EditItemImagePathChanged(this.imagePath);

  final String? imagePath;

  @override
  List<Object?> get props => [imagePath];
}

final class EditItemColorChanged extends EditItemEvent {
  const EditItemColorChanged(this.color);

  final EsnapColor? color;

  @override
  List<Object?> get props => [color];
}

final class EditItemClassificationChanged extends EditItemEvent {
  const EditItemClassificationChanged(this.classification);

  final EsnapClassification? classification;

  @override
  List<Object?> get props => [classification];
}

final class EditItemOccasionsChanged extends EditItemEvent {
  const EditItemOccasionsChanged(this.occasions);

  final List<EsnapOccasion> occasions;

  @override
  List<Object> get props => [occasions];
}

final class EditItemSubmitted extends EditItemEvent {
  const EditItemSubmitted();
}

final class EditItemFavoriteChanged extends EditItemEvent {
  const EditItemFavoriteChanged({required this.favorite});

  final bool favorite;

  @override
  List<Object?> get props => [favorite];
}
