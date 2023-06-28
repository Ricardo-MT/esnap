part of 'detail_item_bloc.dart';

sealed class DetailItemEvent extends Equatable {
  const DetailItemEvent();

  @override
  List<Object?> get props => [];
}

final class DetailItemFavoriteChanged extends DetailItemEvent {
  const DetailItemFavoriteChanged({required this.favorite});

  final bool favorite;

  @override
  List<Object?> get props => [favorite];
}

final class DetailItemDeleteSubmitted extends DetailItemEvent {
  const DetailItemDeleteSubmitted();

  @override
  List<Object?> get props => [];
}
