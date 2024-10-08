part of 'preferences_bloc.dart';

sealed class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object?> get props => [];
}

final class PreferencesInitialCheck extends PreferencesEvent {
  const PreferencesInitialCheck();
}

final class PreferencesFinishOnboarding extends PreferencesEvent {
  const PreferencesFinishOnboarding();
}

final class PreferencesThemeChangeRequest extends PreferencesEvent {
  const PreferencesThemeChangeRequest(this.themeType);

  final ThemeType themeType;

  @override
  List<Object?> get props => [themeType];
}

final class PreferencesThemeChanged extends PreferencesEvent {
  const PreferencesThemeChanged(this.themeType);

  final ThemeType themeType;

  @override
  List<Object?> get props => [themeType];
}

final class PreferencesLanguageChangeRequest extends PreferencesEvent {
  const PreferencesLanguageChangeRequest(this.language);

  final String language;

  @override
  List<Object?> get props => [language];
}

final class PreferencesLanguageChanged extends PreferencesEvent {
  const PreferencesLanguageChanged(this.language);

  final String language;

  @override
  List<Object?> get props => [language];
}
