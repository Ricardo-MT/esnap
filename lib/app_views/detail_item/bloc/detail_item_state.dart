part of 'detail_item_bloc.dart';

enum DetailItemStatus { initial, loading, success, failure }

extension DetailItemStatusX on DetailItemStatus {
  bool get isLoadingOrSuccess => [
        DetailItemStatus.loading,
        DetailItemStatus.success,
      ].contains(this);
  bool get isLoading => this == DetailItemStatus.loading;
}

final class DetailItemState extends Equatable {
  const DetailItemState({
    required this.item,
    this.status = DetailItemStatus.initial,
  });

  final DetailItemStatus status;
  final Item item;

  DetailItemState copyWith({
    DetailItemStatus? status,
    Item? item,
  }) {
    return DetailItemState(
      status: status ?? this.status,
      item: item ?? this.item,
    );
  }

  @override
  List<Object?> get props => [
        status,
        item,
      ];
}
