part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpSubmittedEvent extends SignUpEvent {
  final String email;
  final String password;
  final String DisplayName;

  const SignUpSubmittedEvent({
    required this.email,
    required this.password,
    required this.DisplayName,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpSubmittedWithGoogleEvent extends SignUpEvent {}