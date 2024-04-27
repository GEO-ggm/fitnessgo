// ignore_for_file: prefer_const_constructors

// подключение firebase БД
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'main_set_category_screen.dart';

enum UserType { athlete, coach }


class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  
  
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> with SingleTickerProviderStateMixin{
  UserType? _selectedUserType;
  late AnimationController _progressAnimationController;



Future<void> _saveUserRole(UserType selectedType) async {
  
  String role = selectedType == UserType.athlete ? 'Спортсмен' : 'Тренер';
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'role': role,
      
    }, SetOptions(merge: true)); // Используйте merge, чтобы обновлять существующие данные, не удаляя другие поля
  }
}
  
  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Продолжительность анимации
    );
  
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Запускаем анимацию при построении виджета
    _progressAnimationController.forward();
  }
  
  @override
 Widget build(BuildContext context) {
    Widget buildUserTypeButton(String label, String imageAsset, UserType type) {
      bool isSelected = _selectedUserType == type;
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedUserType = type;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),


            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(imageAsset, width: 80), 
                SizedBox(height: 10), // Указать правильный размер
                Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: LinearProgressIndicator(
          value: 0.25, // Прогресс 1 из 4
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 32, 151, 69)),
        ),
      ),
      
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(22.0),
            child: Text('ШАГ 1/4',
             style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.normal, 
              fontFamily: 'Montserrat'
              )
              ),
          ),
          SizedBox(height: 12),
                    
            Text('Ваша роль?',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 26,
            ),
            ),
            
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildUserTypeButton('Спортсмен', 'assets/2.png', UserType.athlete),
              buildUserTypeButton('Тренер', 'assets/1.png', UserType.coach),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top:25, left:20, right:20),
            child: Text(
             'ВАЖНО: выбор роли определяет ключевые возможности в приложении',
             textAlign: TextAlign.center,
             maxLines: 3,
             style: TextStyle(
             fontWeight: FontWeight.w200,
             fontSize: 13,
             color: Colors.grey,
            ),
            ),
          ),
          SizedBox(height: 12),
         
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 6, 98, 77), // цвет кнопки
              foregroundColor: Colors.white, // цвет содержимого кнопки
              textStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
            ),
            onPressed: _selectedUserType != null
                      ? () async {
                await _saveUserRole(_selectedUserType!); // Сохраняем роль
                // Переход на следующий экран
                Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessInterestScreen(userType: _selectedUserType!, )));
              }
            : null,
            child: Text('Далее'),
          ),
          
        ],
      ),
    );
  }
   @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
    
  }
}
