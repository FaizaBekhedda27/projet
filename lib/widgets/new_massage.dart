import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  final String doctorId;

  const NewMessage({Key? key, required this.doctorId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot<Map<String, dynamic>> userData;

    final enfantsData = await FirebaseFirestore.instance
        .collection('enfants')
        .doc(user.uid)
        .get();

    if (enfantsData.exists) {
      userData = enfantsData;
    } else {
      userData = await FirebaseFirestore.instance
          .collection('medecins')
          .doc(user.uid)
          .get();
    }

    final username = userData.data()!['prenom'] + ' ' + userData.data()!['nom'];
    final userImage = userData.data()!['image_url'];

    FirebaseFirestore.instance.collection('Chat').add({
      'text': enteredMessage,
      'createdat': Timestamp.now(),
      'userId': user.uid,
      'doctorId': widget.doctorId,
      'username': username,
      'userImage': userImage,
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Envoyer un message'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
