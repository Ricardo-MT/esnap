part of 'onboard_bloc.dart';

sealed class OnboardEvent extends Equatable {
  const OnboardEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardSubmitted extends OnboardEvent {
  const OnboardSubmitted();
}
