import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:superchat/pages/message_page/data/message_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('messages');
  var currentUser = FirebaseAuth.instance.currentUser;

  MessageBloc() : super(MessageInitialState()) {
    on<MessageEvent>((event, emit) {
      //emit(MessageLoadingState());
    });

    on<SendMessageEvent>((event, emit) async {
      //emit(MessageLoadingState());

      try {
        final messageModel = MessageModel(
          content: event.content,
          from: currentUser?.uid ?? '',
          to: event.receiver,
          timestamp: DateTime.now(),
        );
        await _messagesCollection.add(messageModel.toJson());
        emit(MessageInitialState());
      } catch (e) {
        emit(MessageErrorState(errorMessage: 'Failed to send message'));
      }
    });

    on<LoadMessagesEvent>((event, emit) async {
      //emit(MessageLoadingState());

      try {
        var stream1 = _messagesCollection.where('to', isEqualTo: currentUser?.uid).where('from', isEqualTo: event.receiver).snapshots();
        var stream2 = _messagesCollection.where('to', isEqualTo: event.receiver).where('from', isEqualTo: currentUser?.uid).snapshots();

        var combinedStream = Rx.combineLatest2<QuerySnapshot, QuerySnapshot, List<DocumentSnapshot>>(
          stream1,
          stream2,
          (querySnapshot1, querySnapshot2) {
            List<DocumentSnapshot> combinedList = [...querySnapshot1.docs, ...querySnapshot2.docs];

            combinedList.sort((a, b) {
              Timestamp timestampA = a['timestamp'];
              Timestamp timestampB = b['timestamp'];

              return timestampA.compareTo(timestampB);
            });

            return combinedList;
          },
        );

        final List<DocumentSnapshot> messages = await combinedStream.first;
        final List<MessageModel> messageModels = messages.map((doc) => MessageModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

        emit(MessageLoadedState(messages: messageModels));
      } catch (e) {
        emit(MessageErrorState(errorMessage: 'Failed to load messages'));
      }
    });
  }
}
