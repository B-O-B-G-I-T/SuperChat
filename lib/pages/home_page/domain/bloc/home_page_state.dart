part of 'home_page_bloc.dart';

sealed class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

final class HomePageInitial extends HomePageState {}

final class HomePageUnauthenticated extends HomePageState {}

final class HomePageLoadedUsers extends HomePageState {
  final List<UserModel> users;
  final UserModel currentUser;
  const HomePageLoadedUsers({required this.users, required this.currentUser});

  @override
  List<Object> get props => [users];
}

final class HomePageSignOut extends HomePageState {
  final String message;

  const HomePageSignOut({required this.message});

  @override
  List<Object> get props => [message];
}

final class HomePageError extends HomePageState {
  final String message;

  const HomePageError({required this.message});

  @override
  List<Object> get props => [message];
}
