part of 'onboard_bloc.dart';

final class OnboardState extends Equatable {
  const OnboardState({
    this.status = FormzSubmissionStatus.initial,
  });

  final FormzSubmissionStatus status;

  OnboardState copyWith({
    FormzSubmissionStatus? status,
  }) {
    return OnboardState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
