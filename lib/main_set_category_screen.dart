// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'main_set_screen.dart';

// Список категорий и соответствующих им эмодзи
final List<Map<String, dynamic>> fitnessCategories = [
  {'name': 'Йога', 'emoji': 'a'},
  {'name': 'Силовая', 'emoji': 'b'},
  {'name': 'Стретчинг', 'emoji': 'c'},
  {'name': 'Кроссфит', 'emoji': 'd'},
  {'name': 'Бодибилдинг', 'emoji': 'f'},
];

class FitnessInterestScreen extends StatefulWidget {
  final UserType userType;
  

  FitnessInterestScreen({Key? key, required this.userType}) : super(key: key); // Конструктор с именованным параметром 'userType'
 

  @override
  _FitnessInterestScreenState createState() => _FitnessInterestScreenState();
}

class _FitnessInterestScreenState extends State<FitnessInterestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Your Interest'),
      ),
      body: Column(
        
        children: [
          Expanded(
            
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: fitnessCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Выбор категории
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          fitnessCategories[index]['emoji'],
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 10),
                        Text(fitnessCategories[index]['name']),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Действие для кнопки продолжить
              },
              child: Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
