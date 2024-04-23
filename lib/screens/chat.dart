import 'package:flutter/material.dart';
import 'package:simple_project/widgets/chat_messages.dart';
import 'package:simple_project/widgets/new_massage.dart';

class ChatScreen extends StatelessWidget {
  final String doctorId;
  final String doctorName;

  const ChatScreen({Key? key, required this.doctorId, required this.doctorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec $doctorName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(doctorId: doctorId),
          ),
          NewMessage(doctorId: doctorId),
        ],
      ),
    );
  }
}
