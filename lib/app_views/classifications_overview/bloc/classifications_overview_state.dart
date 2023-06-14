part of 'classifications_overview_bloc.dart';

enum ClassificationsOverviewStatus { initial, loading, success, failure }

final class ClassificationsOverviewState extends Equatable {
  const ClassificationsOverviewState({
    this.status = ClassificationsOverviewStatus.initial,
    this.classifications = const [],
  });

  final ClassificationsOverviewStatus status;
  final List<EsnapClassification> classifications;

  ClassificationsOverviewState copyWith({
    ClassificationsOverviewStatus Function()? status,
    List<EsnapClassification> Function()? classifications,
  }) {
    return ClassificationsOverviewState(
      status: status != null ? status() : this.status,
      classifications:
          classifications != null ? classifications() : this.classifications,
    );
  }

  @override
  List<Object?> get props => [
        status,
        classifications,
      ];
}
