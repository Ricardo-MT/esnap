part of 'preferences_bloc.dart';

sealed class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object?> get props => [];
}

final class PreferencesCheckFirstLogin extends PreferencesEvent {
  const PreferencesCheckFirstLogin();
}

final class PreferencesFinishOnboarding extends PreferencesEvent {
  const PreferencesFinishOnboarding();
}
