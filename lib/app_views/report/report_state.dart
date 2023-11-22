part of 'report_bloc.dart';

final class ReportState extends Equatable {
  const ReportState({
    this.status = FormzSubmissionStatus.initial,
    this.message = '',
  });

  final FormzSubmissionStatus status;
  final String message;

  ReportState copyWith({
    FormzSubmissionStatus? status,
    String? message,
  }) {
    return ReportState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        status,
        message,
      ];
}
