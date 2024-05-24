import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  List<String> selectedHashtags = [];
  List<String> hashtags = ['#отзыв', '#рецепт', '#занятие', '#курс'];

  void savePost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance.collection('MainBoard').add({
        'title': title,
        'content': content,
        'hashtags': selectedHashtags,
        'timestamp': Timestamp.now(),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать запись'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Заголовок'),
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Содержание'),
                onSaved: (value) => content = value!,
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                children: hashtags.map((hashtag) {
                  return FilterChip(
                    label: Text(hashtag),
                    selected: selectedHashtags.contains(hashtag),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedHashtags.add(hashtag);
                        } else {
                          selectedHashtags.remove(hashtag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Сохранить'),
                onPressed: savePost,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
