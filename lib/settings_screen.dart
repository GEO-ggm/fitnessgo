import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Импортируйте ваш main.dart для доступа к ThemeNotifier
import 'ReportProblem_screen.dart'; // Импортируйте созданный экран
import 'changePass_screnn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late BuildContext _currentContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
      appBar: AppBar(
        title: Text('Настройки', style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Центровка по горизонтали
          children: <Widget>[
            Text(
              'Тема',
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Центровка иконок по горизонтали
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.nights_stay, color: Colors.blueGrey),
                  iconSize: 30.0,
                  onPressed: () {
                    ThemeProvider.controllerOf(context).setTheme('dark_theme');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.wb_sunny, color: Colors.orange),
                  iconSize: 30.0,
                  onPressed: () {
                    ThemeProvider.controllerOf(context).setTheme('light_theme');
                  },
                ),
              ],
            ),
            SizedBox(height: 30.0),
            buildButton(context, 'Сменить пароль', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            }),
            buildButton(context, 'Сообщить о проблеме', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportProblemScreen()),
              );
            }),
            //TODO: Верификация будет в дальнейших обновлениях
            buildButton(context, 'Пройти верификацию', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Пройти верификацию', style: GoogleFonts.poppins()),
                    content: Text('Я еще в разработке...', style: GoogleFonts.poppins()),
                    actions: <Widget>[
                      TextButton(
                        child: Text('ОК', style: GoogleFonts.poppins()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }),
            buildButton(context, 'Выйти из аккаунта', () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthorizationScreen()),
              );
            }),
               buildButton(context, 'Удалить аккаунт', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final TextEditingController passwordController = TextEditingController();
                  return AlertDialog(
                    title: Text('Удалить аккаунт', style: GoogleFonts.poppins()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Вы действительно хотите удалить аккаунт? Это действие необратимо.', style: GoogleFonts.poppins()),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'Введите пароль'),
                          obscureText: true,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Нет', style: GoogleFonts.poppins()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Да', style: GoogleFonts.poppins()),
                        onPressed: () async {
                          final String password = passwordController.text;
                          Navigator.of(context).pop(); // Закрыть диалоговое окно
                          await _deleteAccount(_currentContext, password); // Используем сохраненный контекст и введенный пароль
                        },
                      ),
                    ],
                  );
                },
              );
            }),
          ],
        ),
      ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity, // Кнопка будет растягиваться на всю ширину
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Белый цвет фона
            foregroundColor: Colors.green, // Зеленый цвет текста
            side: BorderSide(color: Colors.green, width: 2), // Зеленый бордер
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.montserrat(fontSize: 18.0, color: Colors.green),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь не найден')),
      );
      return;
    }

    try {
      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password, // Замените на пароль, введенный пользователем для подтверждения
      );

      await user.reauthenticateWithCredential(credential);

      // Delete user's data from Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).delete();
      
      // Удалите все связанные данные в других коллекциях, если это необходимо

      // Delete the user
      await user.delete();
      await DefaultCacheManager().emptyCache();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Аккаунт успешно удален')),
      );

      // start screen
       Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthorizationScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }
}
