// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'main_set_screen.dart';
import 'main_set_info_screen.dart';

import 'package:flutter_svg/flutter_svg.dart';

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
  