import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SignUpSubmittedEvent>((event, emit) async {
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        if (credential.user != null) {
          final user = credential.user!;

          // Créer un objet UserModel avec les informations de l'utilisateur
          UserModel userModel = UserModel(
            id: user.uid,
            displayName: event.DisplayName,
            bio: '', // Ajoutez d'autres champs si nécessaire
          );

          // Convertir l'objet UserModel en une carte JSON
          Map<String, dynamic> userData = userModel.toJson();

          // Ajouter l'utilisateur à la collection "users" dans Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userData);

          emit(SignUpSuccessState());
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        final String errorMessage;

        if (e.code == 'weak-password') {
          errorMessage = 'Le mot de passe est trop faible.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Cet email est déjà associé à un compte existant.';
        } else {
          errorMessage = 'Une erreur est survenue.';
        }

        log(
          'Error while signing in: ${e.code}',
          error: e,
          stackTrace: stackTrace,
          name: 'SignInPage',
        );

        emit(SignUpFailureState(errorMessage));
      }
    });
  }
}
