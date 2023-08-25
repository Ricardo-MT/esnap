part of 'classification_types_overview_bloc.dart';

enum ClassificationTypesOverviewStatus { initial, loading, success, failure }

final class ClassificationTypesOverviewState extends Equatable {
  const ClassificationTypesOverviewState({
    this.status = ClassificationTypesOverviewStatus.initial,
    this.types = const [],
  });

  final ClassificationTypesOverviewStatus status;
  final List<EsnapClassificationType> types;

  ClassificationTypesOverviewState copyWith({
    ClassificationTypesOverviewStatus Function()? status,
    List<EsnapClassificationType> Function()? types,
  }) {
    return ClassificationTypesOverviewState(
      status: status != null ? status() : this.status,
      types: types != null ? types() : this.types,
    );
  }

  @override
  List<Object?> get props => [
        status,
        types,
      ];
}
