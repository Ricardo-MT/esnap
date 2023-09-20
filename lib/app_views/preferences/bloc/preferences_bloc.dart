import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:preferences_repository/preferences_repository.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc({
    required PreferencesRepository preferencesRepository,
  })  : _preferencesRepository = preferencesRepository,
        super(
          const PreferencesState(),
        ) {
    on<PreferencesCheckFirstLogin>(_onCheckFirstLogin);
    on<PreferencesFinishOnboarding>(_onFinishOnboarding);
  }

  final PreferencesRepository _preferencesRepository;

  FutureOr<void> _onFinishOnboarding(
    PreferencesFinishOnboarding event,
    Emitter<PreferencesState> emit,
  ) {
    _preferencesRepository.finishOnboarding();
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.success,
        isFirstLogin: false,
      ),
    );
  }

  FutureOr<void> _onCheckFirstLogin(
    PreferencesCheckFirstLogin event,
    Emitter<PreferencesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      final isFirstLogin = await _preferencesRepository.isFirstLogin();

      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          isFirstLogin: isFirstLogin,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          isFirstLogin: false,
        ),
      );
    }
  }
}
