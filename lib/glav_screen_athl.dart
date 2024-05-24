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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';





class AthleteProfileScreen extends StatelessWidget {
  const AthleteProfileScreen({super.key});
  

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
    UserWorkoutScreen(),
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
        title: Text('FitnessGO'),
        actions: _selectedIndex == 4 // Проверка, выбран ли экран профиля
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
              ]

            : <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen()),
                    );
                  },
                ),
              ],
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


