import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/constants.dart';
import 'package:superchat/pages/home_page/presentation/home_page.dart';
import 'package:superchat/pages/sign_in_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          color: Colors.red,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          backgroundColor: Colors.white,
          accentColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      home: isLoggedIn ? const HomePage() : const SignInPage(),
    );
  }
}
