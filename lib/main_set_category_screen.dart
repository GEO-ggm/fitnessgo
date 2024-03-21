// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'main_set_screen.dart';
import 'main_set_info_screen.dart';

// Список категорий и соответствующих им эмодзи
final List<Map<String, dynamic>> fitnessCategories = [
  {'name': 'Йога', 'emoji': '🧘‍♀️'},
  {'name': 'Силовая', 'emoji': '🏋️'},
  {'name': 'Стретчинг', 'emoji': '🤸‍♂️'},
  {'name': 'Кроссфит', 'emoji': '🚴'},
  {'name': 'Бодибилдинг', 'emoji': '🚴'},
];

class FitnessInterestScreen extends StatefulWidget {
  final UserType userType;
  

  const FitnessInterestScreen({super.key, required this.userType}); // Конструктор с именованным параметром 'userType'
 

  @override
  _FitnessInterestScreenState createState() => _FitnessInterestScreenState();
}

class _FitnessInterestScreenState extends State<FitnessInterestScreen> {
  List<bool> selectedCategories = List.generate(fitnessCategories.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваши интересы'),
      ),
      body: Column(
        
        children: [
          Expanded(
            
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              itemCount: fitnessCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Выбор категории
                    setState(() {
                      selectedCategories[index] = !selectedCategories[index];
                  });
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
                      border: Border.all(
                        color: selectedCategories[index] ? Colors.green : Colors.transparent,
                        width: 3,
                      ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> UserInfoScreen(),),
                    );
              },
              child: Text('Далее'),
            ),
          ),
        ],
      ),
    );
  }
}
