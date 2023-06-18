part of 'detail_item_bloc.dart';

sealed class DetailItemEvent extends Equatable {
  const DetailItemEvent();

  @override
  List<Object?> get props => [];
}

final class DetailItemSubmitted extends DetailItemEvent {
  const DetailItemSubmitted();
}
