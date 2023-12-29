import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/constants.dart';
import 'package:superchat/pages/home_page/domain/bloc/home_page_bloc.dart';
import 'package:superchat/pages/home_page/presentation/widgets/user_list.dart';
import 'package:superchat/pages/setting_page/presentation/setting_page.dart';
import 'package:superchat/pages/sign_in_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => HomePageBloc()..add(HomePageInitialEvent()),
      child: BlocListener<HomePageBloc, HomePageState>(
        listener: (context, state) {
          if (state is HomePageUnauthenticated || state is HomePageSignOut) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInPage()));
          }
        },
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  kAppTitle,
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Text(""),
                backgroundColor: theme.colorScheme.primary,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SettingPage()), (route) => false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      BlocProvider.of<HomePageBloc>(context).add(const HomePageSignOutEvent());
                      //FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
              body: BlocBuilder<HomePageBloc, HomePageState>(
                builder: (context, state) {
                  if (state is HomePageInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is HomePageLoadedUsers) {
                    return UserListWidget(
                      users: state.users,
                      currentUser: state.currentUser,
                    );
                  }
                  return const Center(child: Text('Error'));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
