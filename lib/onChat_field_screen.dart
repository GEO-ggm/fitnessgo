// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fitnessgo/main.dart';

class ChatScreen extends StatelessWidget {
  final String chatId; // или используйте любой другой идентификатор, который поможет загрузить чат

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    // Загрузите сообщения для chatId или используйте StreamBuilder для непрерывного получения сообщений
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат с $chatId'), // Например, здесь может быть имя пользователя
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Заглушка, здесь должно быть количество сообщений в чате
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Сообщение $index'), // Текст сообщения
                  subtitle: Text('Отправитель $index'), // Отправитель сообщения
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Отправить сообщение...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            
            onPressed: () {
              // ... код, требующий `context`
            },
          ),
        ],
      ),
    );
  }
}
