part of 'home_page_bloc.dart';

sealed class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

final class HomePageInitialEvent extends HomePageEvent {}

final class HomePageUnauthenticatedEvent extends HomePageEvent {
  const HomePageUnauthenticatedEvent();

  @override
  List<Object> get props => [];
}

final class HomePageLoadedUsersEvent extends HomePageEvent {
  final List<UserModel> users;

  const HomePageLoadedUsersEvent({required this.users});

  @override
  List<Object> get props => [users];
}

final class HomePageSignOutEvent extends HomePageEvent {
  
  const HomePageSignOutEvent();

  @override
  List<Object> get props => [];
}
