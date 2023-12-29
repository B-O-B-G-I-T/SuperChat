
import 'package:flutter/material.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';
import 'package:superchat/pages/message_page/presentation/message_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
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
  }
}
