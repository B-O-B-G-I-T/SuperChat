import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';
import 'package:superchat/utils/Utils.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<HomePageInitialEvent>((event, emit) async {
      List<UserModel> users = await Utils.getUsers(Utils.getCurrentUserId() ?? "");
      UserModel? currentUser = await Utils.getUser(Utils.getCurrentUserId() ?? "");
      emit(HomePageLoadedUsers(users: users, currentUser: currentUser!));
    });

    on<HomePageUnauthenticatedEvent>((event, emit) {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          emit(HomePageUnauthenticated());
        }
      });
    });

    on<HomePageLoadedUsersEvent>((event, emit) async {
      if (event.users.isEmpty) {
        emit(const HomePageError(message: 'No users found'));
      } else {
        //emit(HomePageLoadedUsers(users: event.users, currentUser: null));
      }
    });

    on<HomePageSignOutEvent>((event, emit) {
      FirebaseAuth.instance.signOut();
      emit(const HomePageSignOut(message: 'Sign out'));
    });
  }

}
