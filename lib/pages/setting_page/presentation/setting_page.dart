import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superchat/constants.dart';
import 'package:superchat/pages/home_page/presentation/home_page.dart';
import 'package:superchat/pages/setting_page/domain/bloc/setting_bloc.dart';
import 'package:superchat/pages/sign_in_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Account Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
            },
          )),
      body: BlocProvider(
        create: (context) => SettingBloc()..add(SettingInitialEvent()),
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            if (state is SettingInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SettingLoaded) {
              _displayNameController.text = state.user.displayName;
              _bioController.text = state.user.bio ?? '';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Display Name',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          hintText: 'displayName',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a display name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Bio',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          hintText: 'Bio',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a bio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      RaisedButton(
                        onPressed: () {
                          final String displayName = _displayNameController.text.trim();
                          final String bio = _bioController.text.trim();

                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<SettingBloc>(context).add(SettingUpdateEvent(displayName: displayName, bio: bio));

                            Fluttertoast.showToast(
                              msg: 'Updating settings...',
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                            );
                          }
                        },
                        color: Colors.blue,
                        child: const Text('Update Settings', style: TextStyle(color: Colors.white)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Delete the account from Firestore
                          BlocProvider.of<SettingBloc>(context).add(SettingDeleteEvent());
                          // Show a success message or navigate to another page
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deleted successfully')));
                          // Navigate to the home page
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SignInPage()), (route) => false);
                        },
                        color: Colors.red,
                        child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Text("error");
          },
        ),
      ),
    );
  }
}

class RaisedButton extends StatelessWidget {
  const RaisedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Center(child: child),
    );
  }
}
