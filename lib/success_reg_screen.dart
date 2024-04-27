// ignore_for_file: prefer_const_constructors

import 'package:fitnessgo/glav_screen.dart';
import 'package:flutter/material.dart';

class RegistrationCompleteScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/back.png"), 
          fit:BoxFit.cover,)
          ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          
          
          children: <Widget>[
            SizedBox(height: 180,),
            Image.asset(
              'assets/succes.png', // Убедитесь, что добавили картинку в папку assets и указали здесь правильный путь
              height: 200, // Вы можете настроить размер под свои нужды
            ),
            SizedBox(height: 24), // Расстояние между картинкой и текстом
            Text(
              'Регистрация завершена!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(), // Используется для того, чтобы кнопка была внизу экрана
            ElevatedButton(
              child: Text('Вперед!'),
              onPressed: () {
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CoachProfileScreen()),
                 );
                // Обработчик нажатия на кнопку
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50), // Задаём минимальную высоту для кнопки
                backgroundColor: Color.fromARGB(255, 6, 98, 77),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                textStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300, fontSize: 22),
              ),
            ),
            
            SizedBox(height: 40,)

          ],
        ),
      ),
    )
    );
  }
}
