part of 'detail_outfit_bloc.dart';

enum DetailOutfitStatus { initial, loading, success, failure }

extension DetailOutfitStatusX on DetailOutfitStatus {
  bool get isLoadingOrSuccess => [
        DetailOutfitStatus.loading,
        DetailOutfitStatus.success,
      ].contains(this);
  bool get isLoading => this == DetailOutfitStatus.loading;
}

final class DetailOutfitState extends Equatable {
  const DetailOutfitState({
    required this.item,
    this.status = DetailOutfitStatus.initial,
  });

  final DetailOutfitStatus status;
  final Outfit item;

  DetailOutfitState copyWith({
    DetailOutfitStatus? status,
    Outfit? item,
  }) {
    return DetailOutfitState(
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
