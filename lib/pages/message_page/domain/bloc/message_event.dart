part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}
class MessageInitialEvent extends MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final String receiver;
  final String content;

  const SendMessageEvent({required this.receiver, required this.content});
}

class LoadMessagesEvent extends MessageEvent {
  final String receiver;

  const LoadMessagesEvent({required this.receiver});
}

class MessagesUpdatedEvent extends MessageEvent {
  final List<MessageModel> messages;

  const MessagesUpdatedEvent({required this.messages});
}

class MessageErrorEvent extends MessageEvent {
  final String errorMessage;

  const MessageErrorEvent({required this.errorMessage});
}
