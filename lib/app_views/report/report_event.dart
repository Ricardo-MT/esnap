part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

final class ReportEventMessageChanged extends ReportEvent {
  const ReportEventMessageChanged(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ReportEventSubmitted extends ReportEvent {
  const ReportEventSubmitted();

  @override
  List<Object?> get props => [];
}
