import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:preferences_api/preferences_api.dart';
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
    on<PreferencesInitialCheck>(_onInitialCheck);
    on<PreferencesFinishOnboarding>(_onFinishOnboarding);
    on<PreferencesThemeChangeRequest>(_onThemeChangeRequest);
    on<PreferencesThemeChanged>(_onThemeChanged);
    preferencesRepository.getThemeAsStream().listen((theme) {
      add(PreferencesThemeChanged(theme));
    });
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

  FutureOr<void> _onInitialCheck(
    PreferencesInitialCheck event,
    Emitter<PreferencesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      final isFirstLogin = await _preferencesRepository.isFirstLogin();
      final theme = await _preferencesRepository.getTheme();

      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          isFirstLogin: isFirstLogin,
          themeMode: _getThemeMode(theme),
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

  FutureOr<void> _onThemeChanged(
    PreferencesThemeChanged event,
    Emitter<PreferencesState> emit,
  ) {
    emit(
      state.copyWith(
        themeMode: _getThemeMode(event.themeType),
      ),
    );
  }

  FutureOr<void> _onThemeChangeRequest(
    PreferencesThemeChangeRequest event,
    Emitter<PreferencesState> emit,
  ) {
    _preferencesRepository.setTheme(event.themeType);
  }
}

ThemeMode _getThemeMode(ThemeType themeType) {
  return ThemeMode.values.firstWhere(
    (element) => element.name == themeType.name,
    orElse: () => ThemeMode.system,
  );
}
