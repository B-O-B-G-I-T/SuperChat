part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpSubmittedState extends SignUpState {}

class SignUpFailureState extends SignUpState {
  final String error;

  SignUpFailureState(this.error);
  }
