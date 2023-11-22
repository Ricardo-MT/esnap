import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:report_repository/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc({
    required ReportRepository reportRepository,
  })  : _reportRepository = reportRepository,
        super(const ReportState()) {
    on<ReportEventMessageChanged>(_onMessageChanged);
    on<ReportEventSubmitted>(_onSubmitted);
  }
  final ReportRepository _reportRepository;

  FutureOr<void> _onMessageChanged(
    ReportEventMessageChanged event,
    Emitter<ReportState> emit,
  ) {
    emit(state.copyWith(message: event.message));
  }

  FutureOr<void> _onSubmitted(
    ReportEventSubmitted event,
    Emitter<ReportState> emit,
  ) async {
    if (state.message.isNotEmpty) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _reportRepository.sendFeedback(
          platform: Platform.operatingSystem,
          message: state.message,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on Exception {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
