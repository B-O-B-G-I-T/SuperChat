import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;

  const MessageInput({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Enter your message...',
          ),
        ),
      ),
    );
  }
}
