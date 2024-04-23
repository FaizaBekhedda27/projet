import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_project/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  final String doctorId;

  const ChatMessages({Key? key, required this.doctorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticator = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('Chat')
          .where('userId', whereIn: [authenticator.uid, doctorId])
          .orderBy(
            'createdat',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong ....'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        print('Nombre de messages récupérés: ${loadedMessages.length}');

        // Afficher les messages récupérés
        loadedMessages.forEach((message) {
          print('Message: ${message.data()}');
        });

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessages = loadedMessages[index].data();
            final String messageText = chatMessages['text'];
            final String messageUserId = chatMessages['userId'];
            final String messageUsername = chatMessages['username'];
            final String messageUserImage = chatMessages['userImage'];
            final bool isMe = authenticator.uid == messageUserId;

            return MessageBubble(
              userImage: messageUserImage,
              username: messageUsername,
              message: messageText,
              isMe: isMe,
            );
          },
        );
      },
    );
  }
}



class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.userImage,
    this.username,
    this.message,
    this.isMe,
    this.isFirstInSequence = false,
    this.onTap,
  }) : super(key: key);
  
  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String? message;
  final bool? isMe;
  final VoidCallback? onTap; // Ajout du paramètre onTap

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            right: isMe! ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage!),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence)
                    const SizedBox(
                      height: 18,
                    ),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                        color: isMe!
                            ? Colors.grey[300]
                            : theme.colorScheme.secondary.withAlpha(200),
                        borderRadius: BorderRadius.only(
                          topLeft: !isMe! && isFirstInSequence
                              ? Radius.zero
                              : const Radius.circular(12),
                          topRight: isMe! && isFirstInSequence
                              ? Radius.zero
                              : const Radius.circular(12),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        )),
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      message!,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe!
                            ? Colors.black87
                            : theme.colorScheme.onSecondary,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
