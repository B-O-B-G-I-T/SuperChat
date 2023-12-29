import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';
import 'package:superchat/utils/Utils.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<SettingInitialEvent>((event, emit) async {
      UserModel? currentUser = await Utils.getUser(Utils.getCurrentUserId() ?? "");
      emit(SettingLoaded(user: currentUser!));
    });

    on<SettingUpdateEvent>((event, emit) async {
      final id = Utils.getCurrentUserId();
      try {
        UserModel user = UserModel(id: id!, displayName: event.displayName, bio: event.bio);

        await FirebaseFirestore.instance.collection('users').doc(id).update({
          'displayName': user.displayName,
          'bio': user.bio,
        });

        emit(SettingLoaded(user: user));
      } catch (e) {
        // Handle error
      }
    });

    on<SettingDeleteEvent>((event, emit) async {
      final id = Utils.getCurrentUserId();
      try {
        await FirebaseFirestore.instance.collection('users').doc(id).delete();
        await FirebaseAuth.instance.currentUser!.delete();
        emit(SettingDelete());
      } catch (e) {
        // Handle error
      }
    });
  }


}
