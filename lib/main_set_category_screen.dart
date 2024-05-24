// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'main_set_screen.dart';
import 'main_set_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Список категорий и соответствующих им эмодзи
final List<Map<String, dynamic>> fitnessCategories = [
  {'name': 'Йога', 'icon': 'assets/icons/yoga.svg'},
  {'name': 'Силовые', 'icon': 'assets/icons/sila.svg'},
  {'name': 'Кардио', 'icon': 'assets/icons/cardio.svg'},
  {'name': 'Массонабор', 'icon': 'assets/icons/massnab.svg'},
  {'name': 'Поддержание', 'icon': 'assets/icons/poderzh.svg'},
  {'name': 'Похудение', 'icon': 'assets/icons/pohud.svg'},
  {'name': 'Правильное питание', 'icon': 'assets/icons/applepit.svg'},
  {'name': 'Интуитивное питание', 'icon': 'assets/icons/intlpit.svg'},
  {'name': 'Вегетарианец', 'icon': 'assets/icons/vegetar.svg'},
  
];


class FitnessInterestScreen extends StatefulWidget {
  final UserType userType;
  const FitnessInterestScreen({super.key, required this.userType}); // Конструктор с именованным параметром 'userType'

  @override
  _FitnessInterestScreenState createState() => _FitnessInterestScreenState();
}
class _FitnessInterestScreenState extends State<FitnessInterestScreen> {
  List<bool> selectedCategories = List.generate(fitnessCategories.length, (index) => false);
  late final String userId; // Создаем переменную для хранения userId
  late final DocumentReference userDoc; // Создаем переменную для хранения ссылки на документ
@override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser; // Получаем текущего пользователя
    if (user != null) {
      userId = user.uid; // Получаем и сохраняем uid пользователя
      userDoc = FirebaseFirestore.instance.collection('Users').doc(userId); // Получаем ссылку на документ пользователя
    }
  }


  // Функция для сохранения предпочтений пользователя
  Future<void> _savePreferencesToFirebase() async {
    // Создаем Map для отправки в Firebase
    final selectedPreferences = <String, bool>{};
    for (var i = 0; i < fitnessCategories.length; i++) {
      selectedPreferences[fitnessCategories[i]['name']] = selectedCategories[i];
    }

    try {
      // Добавляем выбранные предпочтения в коллекцию
      await userDoc.set({
        'choose': selectedPreferences,
      }, SetOptions(merge: true));

      Future<void> saveUserRole(String role) async {
      await userDoc.set({
      'role': role,
      }, SetOptions(merge: true)); // Используйте merge, чтобы обновить документ, не удаляя существующие поля
}

      print('Preferences saved successfully!');
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваши интересы'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: fitnessCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategories[index] = !selectedCategories[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 49, 113, 51).withOpacity(0.2),
                        
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: selectedCategories[index] ? Colors.green : Colors.transparent,
                          width: 4,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            fitnessCategories[index]['icon'],
                            
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                          fitnessCategories[index]['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                             // Установка белого цвета для текста
                          ),
                        ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: ElevatedButton(
              onPressed: () {
                 _savePreferencesToFirebase();
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> UserInfoScreen()));
              },
              child: Text('Далее'),
            ),
          ),
        ],
      ),
    );
  }
}
