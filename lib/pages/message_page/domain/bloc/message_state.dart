part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

class MessageInitialState extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final List<MessageModel> messages;

  MessageLoadedState({required this.messages});
}

class MessageErrorState extends MessageState {
  final String errorMessage;

  MessageErrorState({required this.errorMessage});
}

