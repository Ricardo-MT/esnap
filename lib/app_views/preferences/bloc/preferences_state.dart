part of 'preferences_bloc.dart';

final class PreferencesState extends Equatable {
  const PreferencesState({
    this.status = FormzSubmissionStatus.inProgress,
    this.isFirstLogin,
    this.themeMode = ThemeMode.system,
  });

  final FormzSubmissionStatus status;
  final bool? isFirstLogin;
  final ThemeMode themeMode;

  PreferencesState copyWith({
    FormzSubmissionStatus? status,
    bool? isFirstLogin,
    ThemeMode? themeMode,
  }) {
    return PreferencesState(
      status: status ?? this.status,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [status, isFirstLogin ?? 'null', themeMode];
}
