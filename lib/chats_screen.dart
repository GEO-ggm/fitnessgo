import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'onChat_field_screen.dart';

String getChatId(String userId1, String userId2) {
  return userId1.hashCode <= userId2.hashCode
      ? '$userId1-$userId2'
      : '$userId2-$userId1';
}

class ChatScreen extends StatefulWidget {
  
  @override
  _ChatScreenState createState() => _ChatScreenState();
  
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> _refreshChats() async {
    setState(() {
      // Повторный запрос к БД на лист тренировок
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:RefreshIndicator(
        onRefresh: _refreshChats,
        child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userDocs = userSnapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (ctx, index) {
              var userData = userDocs[index].data() as Map<String, dynamic>;
              var peerUserId = userDocs[index].id;
              var userImage = userData['photoURL'] as String? ?? 'assets/example/123.jpeg';

              return StreamBuilder<DocumentSnapshot>(
                
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(getChatId(FirebaseAuth.instance.currentUser!.uid, peerUserId))
                    .snapshots(),
                builder: (context, chatSnapshot) {
                  var lastMessage = 'Нет сообщений';
                  var lastMessageTime = '';
                  if (chatSnapshot.data != null && chatSnapshot.data!.exists) {
                    var chatData = chatSnapshot.data!.data() as Map<String, dynamic>;
                    lastMessage = chatData['lastMessage'] ?? lastMessage;
                    if (chatData['lastMessageTime'] != null) {
                      DateTime messageTime = (chatData['lastMessageTime'] as Timestamp).toDate();
                      lastMessageTime = DateFormat('HH:mm').format(messageTime);
                    }
                  }
                  
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:  NetworkImage(userImage),
                    ),
                    title: Text('${userData['name']} ${userData['surname']}'),
                    subtitle: Text(lastMessage),
                    trailing: Text(lastMessageTime),
                     onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IndividualChatScreen(
                            peerUserId: peerUserId,
                            userName: '${userData['name']} ${userData['surname']}',
                            userImage: userImage,
                         ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      ),
    );
  }
}