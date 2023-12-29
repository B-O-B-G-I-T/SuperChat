import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/constants.dart';
import 'package:superchat/pages/home_page/presentation/home_page.dart';
import 'package:superchat/pages/sign_in_page.dart';
import 'package:superchat/pages/sign_up/domain/bloc/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SignUpBloc _signUpBloc = SignUpBloc();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _displayNameFieldController = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    _displayNameFieldController.dispose();
    _signUpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => _signUpBloc,
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpInitial) {
            const Center(child: CircularProgressIndicator());
            log('SignUpInitial');
          }
          if (state is SignUpSuccessState) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
          }
          if (state is SignUpFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignUpPage()));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignInPage())),
            ),
            title: const Text(kAppTitle),
            backgroundColor: theme.colorScheme.primary,
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Insets.medium),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Créez votre compte Superchat',
                            style: theme.textTheme.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Insets.extraLarge),
                          const Text(
                            'displayName',
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            controller: _displayNameFieldController,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              hintText: 'displayName',
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) => value != null ? null : 'displayName invalide',
                          ),
                          const SizedBox(height: Insets.medium),
                          const Text(
                            'Email',
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            controller: _emailFieldController,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) => value != null && EmailValidator.validate(value) ? null : 'Email invalide',
                          ),
                          const SizedBox(height: Insets.medium),
                          const Text(
                            'Mot de passe',
                            textAlign: TextAlign.center,
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return TextFormField(
                                controller: _passwordFieldController,
                                autofillHints: const [AutofillHints.password],
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  hintText: 'Mot de passe',
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _showPassword = !_showPassword),
                                    icon: _showPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              );
                            },
                          ),
                          const SizedBox(height: Insets.medium),

                          // Bouton d'inscription
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _signUp(),
                              child: const Text('S\'inscrire'),
                            ),
                          ),
                          const SizedBox(height: Insets.medium),
                          const Text(
                            'Vous avez déjà un compte ?',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SignInPage())),
                            child: const Text('Se connecter'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> isEmailInDatabase(String email) async {
    // Obtenez une référence à la collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Utilisez where pour filtrer les documents par email
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

    // Convertissez les documents en JSON
    final usersWithEmailJson = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Si la liste n'est pas vide, l'email est dans la base de données
    return usersWithEmailJson.isNotEmpty;
  }

  Future<void> _signUp() async {
    //final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      _signUpBloc.add(SignUpSubmittedEvent(
        email: _emailFieldController.text.trim(),
        password: _passwordFieldController.text.trim(),
        DisplayName: _displayNameFieldController.text.trim(),
      ));

      //navigator.pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }
}
