part of 'edit_item_bloc.dart';

sealed class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object> get props => [];
}

final class EditItemColorChanged extends EditItemEvent {
  const EditItemColorChanged(this.color);

  final String color;

  @override
  List<Object> get props => [color];
}

final class EditItemClassificationChanged extends EditItemEvent {
  const EditItemClassificationChanged(this.classification);

  final String classification;

  @override
  List<Object> get props => [classification];
}

final class EditItemOccasionsChanged extends EditItemEvent {
  const EditItemOccasionsChanged(this.occasions);

  final List<String> occasions;

  @override
  List<Object> get props => [occasions];
}

final class EditItemSubmitted extends EditItemEvent {
  const EditItemSubmitted();
}
