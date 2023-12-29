import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/pages/message_page/domain/bloc/message_bloc.dart';
import 'package:superchat/pages/message_page/presentation/widgets/message_button_widget.dart';
import 'package:superchat/pages/message_page/presentation/widgets/message_input_widget.dart';
import 'package:superchat/pages/message_page/presentation/widgets/message_list_widget.dart';

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
                  // return buildMessageList(state.messages);
                  return MessageList(
                    messages: state.messages,
                    id: widget.id,
                    displayName: widget.displayName,
                  );
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
                MessageInput(controller: _messageController),
                MessageButton(
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final bloc = context.read<MessageBloc>();
    bloc.add(SendMessageEvent(
      receiver: widget.id,
      content: _messageController.text,
    ));
    _messageController.clear();
    
  }
}
