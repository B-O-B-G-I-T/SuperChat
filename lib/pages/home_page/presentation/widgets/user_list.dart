import 'package:flutter/material.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';
import 'package:superchat/pages/home_page/presentation/widgets/user_card.dart';
import 'package:superchat/pages/home_page/presentation/widgets/user_info.dart';

class UserListWidget extends StatelessWidget {
  final List<UserModel> users;
  final UserModel currentUser;

  UserListWidget({required this.users, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return UserCard(user: users[index]);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: UserInfo(currentUser: currentUser),
        ),
      ],
    );
  }
}