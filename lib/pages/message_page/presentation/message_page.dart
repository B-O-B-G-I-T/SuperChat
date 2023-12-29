import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/pages/message_page/data/message_model.dart';
import 'package:superchat/pages/message_page/domain/bloc/message_bloc.dart';

class MessagePage extends StatelessWidget {
  final String id;
  final String displayName;

  const MessagePage({Key? key, required this.id, required this.displayName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc(),
      child: MessagePageContent(id: id, displayName: displayName),
    );
  }
}

class MessagePageContent extends StatefulWidget {
  final String id;
  final String displayName;

  const MessagePageContent({
    Key? key,
    required this.id,
    required this.displayName,
  }) : super(key: key);

  @override
  _MessagePageContentState createState() => _MessagePageContentState();
}

class _MessagePageContentState extends State<MessagePageContent> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayName),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageInitialState) {
                  final bloc = context.read<MessageBloc>();
                  bloc.add(LoadMessagesEvent(receiver: widget.id));
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageErrorState) {
                  return Center(child: Text(state.errorMessage));
                } else if (state is MessageLoadedState) {
                  return buildMessageList(state.messages);
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final bloc = context.read<MessageBloc>();
                    bloc.add(SendMessageEvent(
                      receiver: widget.id,
                      content: _messageController.text,
                    ));
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageList(List<MessageModel> messages) {
    final theme = Theme.of(context);

    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        var messageModel = messages[messages.length - 1 - index];

        bool isCurrentUser = messageModel.from != widget.id;

        Color bubbleColor = isCurrentUser ? theme.colorScheme.primary : Colors.grey;
        CrossAxisAlignment alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Text(
                isCurrentUser ? "moi" : widget.displayName,
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
                  messageModel.content,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
