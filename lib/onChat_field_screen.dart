import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Функция для создания уникального идентификатора чата
String getChatId(String userId, String peerId) {
  return userId.hashCode <= peerId.hashCode
      ? '$userId-$peerId'
      : '$peerId-$userId';
}

class FullScreenImage extends StatelessWidget {
  final String url;

  FullScreenImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Image.network(url),
        ),
      ),
    );
  }
}


class IndividualChatScreen extends StatefulWidget {
  final String peerUserId;
  final String userName; // Предположим, что имя пользователя передаётся при навигации
  final String userImage; // и URL изображения пользователя

  IndividualChatScreen({required this.peerUserId,required this.userName, required this.userImage});

  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
   final String text = _messageController.text.trim();
   final currentUser = FirebaseAuth.instance.currentUser;

  if (text.isNotEmpty && currentUser != null) {
    final chatId = getChatId(currentUser.uid, widget.peerUserId);
    final message = {
      'text': text,
      'createdAt': FieldValue.serverTimestamp(), // Зафиксировать время отправки сообщения
      'userId': currentUser.uid, // ID отправителя
      // Другие поля, такие как имя отправителя, аватар и т.д.
    };
     FirebaseFirestore.instance.collection('chats/$chatId/messages').add(message);
     
     FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // Используем merge, чтобы не удалять существующие данные


    _messageController.clear();
  }
}

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    String chatId = getChatId(currentUser!.uid, widget.peerUserId);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userImage),
            ),
            SizedBox (width: 10),
            Text(widget.userName),
          ],
        ),
            leading: BackButton(
              onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              
              stream: FirebaseFirestore.instance.collection('chats/$chatId/messages').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Что-то пошло не так'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder:  (context, index){
                    var messageData= snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    bool myMessage = messageData['userId'] == currentUser.uid;
                    Widget content; // Содержимое сообщения, текст или изображение
                    if (messageData['hasAttachment'] == true && messageData['attachmentUrl'] != null) {
                      // Если это вложение
                      content = InkWell(
                        onTap: () {
                          // Открыть изображение в полноэкранном режиме
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FullScreenImage(url: messageData['attachmentUrl']),
                          ));
                        },
                        child: Image.network(
                          messageData['attachmentUrl'],
                          height: 200,  // Высота изображения
                          width: 200, // Ширина изображения для удобства
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      // Если это текстовое сообщение
                      content = Text(
                        messageData['text'],
                        style: TextStyle(fontSize: 16),
                      );
                    }
                    return Align(
                      alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                       padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: myMessage ? Colors.green[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                    ),
                    child: content,
                    ),
                    );
                  }
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadFile() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    try {
      // Загрузите файл в Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('chat_uploads/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Отправка сообщения с URL-ссылкой на файл в Firestore
      _sendMessageWithAttachment(downloadUrl);
    } catch (e) {
      print('Ошибка загрузки файла: $e');
    }
  }
}

void _sendMessageWithAttachment(String fileUrl) {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final chatId = getChatId(currentUser.uid, widget.peerUserId);
    FirebaseFirestore.instance.collection('chats/$chatId/messages').add({
      'text': '📎 Attachment',
      'attachment': fileUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUser.uid,
      'hasAttachment': true,
      'attachmentUrl': fileUrl,
    });
  }
}


  Widget _buildMessageInputField() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            IconButton(
             onPressed: _pickAndUploadFile,
             icon: Icon(Icons.attach_file),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Введите сообщение...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
                child: Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
