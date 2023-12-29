import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/constants.dart';
import 'package:superchat/pages/home_page/domain/bloc/home_page_bloc.dart';
import 'package:superchat/pages/message_page/presentation/message_page.dart';
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
                    return Column(
                      children: [
                        Expanded(
                          flex: 10,
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (BuildContext context, int index) {
                              var user = state.users[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MessagePage(id: user.id, displayName: user.displayName),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: Text(
                                        user.displayName[0].toUpperCase(),
                                        style: const TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      user.displayName,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      user.bio ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: const Icon(Icons.arrow_forward),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity, // Prend toute la largeur disponible
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("YO ${state.currentUser.displayName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(state.currentUser.bio ?? ''),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
