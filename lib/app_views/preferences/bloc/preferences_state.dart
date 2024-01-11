part of 'preferences_bloc.dart';

final class PreferencesState extends Equatable {
  const PreferencesState({
    required this.isUpToDate,
    this.status = FormzSubmissionStatus.inProgress,
    this.isFirstLogin,
    this.themeMode = ThemeMode.system,
    this.language = 'en',
  });

  final FormzSubmissionStatus status;
  final bool? isFirstLogin;
  final ThemeMode themeMode;
  final String language;
  final bool isUpToDate;

  PreferencesState copyWith({
    FormzSubmissionStatus? status,
    bool? isFirstLogin,
    ThemeMode? themeMode,
    String? language,
    bool? isUpToDate,
  }) {
    return PreferencesState(
      status: status ?? this.status,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      isUpToDate: isUpToDate ?? this.isUpToDate,
    );
  }

  @override
  List<Object> get props => [
        status,
        isFirstLogin ?? 'null',
        themeMode,
        language,
        isUpToDate,
      ];
}
