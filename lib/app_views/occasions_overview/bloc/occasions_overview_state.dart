part of 'occasions_overview_bloc.dart';

enum OccasionsOverviewStatus { initial, loading, success, failure }

final class OccasionsOverviewState extends Equatable {
  const OccasionsOverviewState({
    this.status = OccasionsOverviewStatus.initial,
    this.occasions = const [],
  });

  final OccasionsOverviewStatus status;
  final List<EsnapOccasion> occasions;

  OccasionsOverviewState copyWith({
    OccasionsOverviewStatus Function()? status,
    List<EsnapOccasion> Function()? occasions,
  }) {
    return OccasionsOverviewState(
      status: status != null ? status() : this.status,
      occasions: occasions != null ? occasions() : this.occasions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        occasions,
      ];
}
