// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitnessgo/calendar_screen.dart';
import 'package:fitnessgo/chats_screen.dart';
import 'package:fitnessgo/glav_world.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fitnessgo/training_screen.dart';
import 'package:fitnessgo/myprofile_screen.dart';
import 'package:fitnessgo/notify_screen.dart';



void main() => runApp(const CoachProfileScreen());

class CoachProfileScreen extends StatelessWidget {
  const CoachProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    ScheduleScreen(),
    MainMenuScreen(),
    TrainingsScreen(),
    ProfileScreen(),
  ];
  
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         // Иконка для возвращения на предыдущий экран
        title: Text("FitnessGo",
        style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Montserrat'),
        ), // Название приложения или логотип
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
                      
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_)=>NotificationsScreen()),
              );
            
            
            },
          ),
        ]
      ),
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/Chat.svg', width: 34,),
            label: 'Чаты',
            backgroundColor: Colors.white,
            
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/Calendar.svg', width: 34,),
            label: 'календарь',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/logo.svg', width: 34,),
            label: 'Главная',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/Weight.svg', width: 34,),
            label: 'Тренировки',
            backgroundColor:Colors.white,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/3User.svg', width: 34,),
            label: 'Личное',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
