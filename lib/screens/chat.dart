import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FirebaseUtils {
  static Future<Map<String, String>> getCurrentUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('medecins')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        final username = userDoc['username'] as String?;
        final imageUrl = userDoc['image_url'] as String?;
        return {'username': username ?? '', 'imageUrl': imageUrl ?? ''};
      }
    }
    return {
      'username': '',
      'imageUrl': ''
    }; // Retourne des valeurs par défaut si l'utilisateur n'est pas connecté ou si ses données ne sont pas disponibles
  }
}

class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({required this.text, required this.isSender});
}

class DoctorChatPage extends StatefulWidget {
  final String userId;
  final String doctorName;
  final String imagePath;

  DoctorChatPage({
    required this.userId,
    required this.doctorName,
    required this.imagePath,
  });

  @override
  _DoctorChatPageState createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream;

  String? _username = ''; // Initialize with default value
  String? _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _messageStream = FirebaseFirestore.instance
        .collection('conversations')
        .doc(chatRoomId())
        .collection('messages')
        .orderBy('date', descending: false)
        .snapshots();
  }

  void _loadUserInfo() async {
    final userInfo = await FirebaseUtils.getCurrentUserInfo();
    setState(() {
      _username = userInfo['username']?? ''; // Use null-aware operator
      _imageUrl = userInfo['imageUrl']?? ''; 
    });
  }

  String chatRoomId() {
    List users = [FirebaseAuth.instance.currentUser!.uid, widget.userId];
    users.sort();
    return '${users[0]}_${users[1]}';
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser!.uid;
      final uuid = Uuid().v4();

      FirebaseFirestore.instance
          .collection('conversations')
          .doc(chatRoomId())
          .collection('messages')
          .doc(uuid)
          .set({
        'message': _messageController.text,
        'sender_id': uid,
        'date': Timestamp.now(),
        'message_id': uuid,
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imagePath),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${widget.doctorName}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.videocam),
                    SizedBox(width: 20),
                    Icon(Icons.call),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final messages = snapshot.data?.docs ?? [];
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messagemap = messages[index].data() as Map<String, dynamic>;
                    final senderid = messagemap['sender_id'] as String?;
                    final isSender = senderid == FirebaseAuth.instance.currentUser!.uid;
                    return isSender
                        ? SenderRowView(
                            key: UniqueKey(),
                            message: ChatMessage(
                              text: messagemap['message'] ?? '',
                              isSender: isSender,
                            ),
                            imageUrl: _imageUrl,
                            username: _username,
                          )
                        : ReceiverRowView(
                            key: UniqueKey(),
                            message: ChatMessage(
                              text: messagemap['message'] ?? '',
                              isSender: isSender,
                            ),
                            imagePath: widget.imagePath,
                          );
                  },
                );
              },
            ),
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _sendMessage,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SenderRowView extends StatelessWidget {
  final ChatMessage message;
  final String? imageUrl;
  final String? username;

  SenderRowView({
    Key? key,
    required this.message,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
      ),
      visualDensity: VisualDensity.comfortable,
      title: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
            ),
            child: Text(
              message.text,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white),
              softWrap: true,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 8, top: 4),
        child: Text(
          DateFormat.jm().format(DateTime.now()),
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}

class ReceiverRowView extends StatelessWidget {
  final ChatMessage message;
  final String imagePath;

  ReceiverRowView({
    Key? key,
    required this.message,
    required this.imagePath,
  }) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    return ListTile(
      key: key, // Add key here
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
          backgroundImage: NetworkImage(imagePath),
        ),
      ),
      title: Wrap(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.white, 
            ),
          ),
        ),
      ]),
      trailing: Container(
        width: 50,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 8, top: 4),
        child: Text(DateFormat.jm().format(DateTime.now()), style: TextStyle(fontSize: 10)),
      ),
    );
  }
}
