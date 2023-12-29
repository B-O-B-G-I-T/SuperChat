import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String from;
  final String to;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.from,
    required this.to,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      from: json['from'],
      to: json['to'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
