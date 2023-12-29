import 'package:flutter/material.dart';
import 'package:superchat/pages/message_page/data/message_model.dart';
import 'package:superchat/pages/message_page/presentation/widgets/message_bubble_widget.dart';

class MessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final String id;
  final String displayName;

  const MessageList({Key? key, required this.messages, required this.id, required this.displayName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        MessageModel messageModel = messages[messages.length - 1 - index];
        bool isCurrentUser = messageModel.from != id;

        return MessageBubble(message: messageModel, isCurrentUser: isCurrentUser, displayName: displayName);
      },
    );
  }
}
