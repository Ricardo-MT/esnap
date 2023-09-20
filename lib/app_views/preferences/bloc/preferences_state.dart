part of 'preferences_bloc.dart';

final class PreferencesState extends Equatable {
  const PreferencesState({
    this.status = FormzSubmissionStatus.inProgress,
    this.isFirstLogin,
  });

  final FormzSubmissionStatus status;
  final bool? isFirstLogin;

  PreferencesState copyWith({
    FormzSubmissionStatus? status,
    bool? isFirstLogin,
  }) {
    return PreferencesState(
      status: status ?? this.status,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }

  @override
  List<Object> get props => [status, isFirstLogin ?? 'null'];
}
