part of 'colors_overview_bloc.dart';

enum ColorsOverviewStatus { initial, loading, success, failure }

final class ColorsOverviewState extends Equatable {
  const ColorsOverviewState({
    this.status = ColorsOverviewStatus.initial,
    this.colors = const [],
  });

  final ColorsOverviewStatus status;
  final List<EsnapColor> colors;

  ColorsOverviewState copyWith({
    ColorsOverviewStatus Function()? status,
    List<EsnapColor> Function()? colors,
  }) {
    return ColorsOverviewState(
      status: status != null ? status() : this.status,
      colors: colors != null ? colors() : this.colors,
    );
  }

  @override
  List<Object?> get props => [
        status,
        colors,
      ];
}
