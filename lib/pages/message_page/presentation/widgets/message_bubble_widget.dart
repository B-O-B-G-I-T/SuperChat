import 'package:flutter/material.dart';
import 'package:superchat/pages/message_page/data/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isCurrentUser;
  final String displayName;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.displayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bubbleColor = isCurrentUser ? theme.colorScheme.primary : Colors.grey;
    CrossAxisAlignment alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            isCurrentUser ? "moi" : displayName,
            style: const TextStyle(fontSize: 12.0),
          ),
          const SizedBox(height: 4.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message.content,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
