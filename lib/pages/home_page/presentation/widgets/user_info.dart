import 'package:flutter/material.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';

class UserInfo extends StatelessWidget {
  final UserModel currentUser;

  UserInfo({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("YO ${currentUser.displayName}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(currentUser.bio ?? ''),
          ],
        ),
      ),
    );
  }
}