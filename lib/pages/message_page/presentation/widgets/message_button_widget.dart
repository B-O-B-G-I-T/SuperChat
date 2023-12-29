import 'package:flutter/material.dart';

class MessageButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Function() onPressed;

  const MessageButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: onPressed,
    );
  }
}
