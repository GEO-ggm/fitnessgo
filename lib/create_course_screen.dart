import 'package:fitnessgo/step_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'step_screen.dart'; 
import 'course.dart';


class CreateCourseScreen extends StatefulWidget {
  @override
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String courseTitle = '';
  String courseDescription = '';
  List<Stage> stages = [];

void saveCourse() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    
    // Получаем текущего пользователя
    User? user = FirebaseAuth.instance.currentUser;

    // Создаем курс с необходимыми полями
    final newCourse = Course(
      id: '', // Firestore автоматически присвоит ID
      title: courseTitle,
      description: courseDescription,
      stages: stages,
      uid: user!.uid, // Сохраняем uid текущего пользователя
    );

    await FirebaseFirestore.instance
        .collection('courses')
        .add(newCourse.toMap())
        .then((DocumentReference doc) {
          print('Course added with ID: ${doc.id}');
        })
        .catchError((error) {
          print('Error adding course: $error');
        });

    Navigator.pop(context);
  }
}

  void addStage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateStageScreen(onStageAdded: (stage) {
        setState(() {
          stages.add(stage);
        });
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать курс'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveCourse,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название курса'),
                onSaved: (value) => courseTitle = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Описание курса'),
                onSaved: (value) => courseDescription = value!,
              ),
              SizedBox(height: 20),
              ...stages.map((stage) => ListTile(
                    title: Text(stage.name),
                    subtitle: Text('Подходы: ${stage.sets}, Время: ${stage.duration} мин'),
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addStage,
                child: Text('Добавить этап'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateStageScreen extends StatefulWidget {
  final Function(Stage) onStageAdded;

  CreateStageScreen({required this.onStageAdded});

  @override
  _CreateStageScreenState createState() => _CreateStageScreenState();
}

class _CreateStageScreenState extends State<CreateStageScreen> {
  final _formKey = GlobalKey<FormState>();
  String stageName = '';
  int sets = 0;
  int duration = 0;
  String videoUrl = '';

  void saveStage() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newStage = Stage(
        name: stageName,
        sets: sets,
        duration: duration,
        videoUrl: videoUrl,
      );

      widget.onStageAdded(newStage);
      Navigator.pop(context);
    }
  }

  void uploadVideo() async {
    // Реализуйте логику загрузки видео в Firestore и получите videoUrl
    // После успешной загрузки, обновите переменную videoUrl
    // Пример:
    // videoUrl = await uploadVideoToFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать этап'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название упражнения'),
                onSaved: (value) => stageName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Количество подходов'),
                keyboardType: TextInputType.number,
                onSaved: (value) => sets = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Время (минуты)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => duration = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadVideo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    Text('Загрузить видео'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveStage,
                child: Text('Сохранить этап'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


