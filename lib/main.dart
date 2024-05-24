// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitnessgo/main_set_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnessgo/registration_screen.dart';
import 'package:fitnessgo/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'glav_screen.dart';
import 'glav_screen_athl.dart';
import 'main_set_category_screen.dart';
import 'package:provider/provider.dart';
import 'ThemeNotifier.dart';
import 'settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  bool isLoggedIn = await checkLoginStatus();
  String userType = isLoggedIn ? await getUserType() : '';

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(isLoggedIn: isLoggedIn, userType: userType),
    ),
  );
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('user_token');
}

Future<String> getUserType() async {
  final prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('user_token');
  if (uid == null) {
    return '';
  }
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  return userDoc['role'];
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userType;

  MyApp({required this.isLoggedIn, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: isLoggedIn
              ? (userType == 'Тренер' ? CoachProfileScreen() : AthleteProfileScreen())
              : AuthorizationScreen(),
        );
      },
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void setDarkTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }
}

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  AuthorizationScreenState createState() => AuthorizationScreenState();
}

class AuthorizationScreenState extends State<AuthorizationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
        String userType = userDoc['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', userCredential.user!.uid);
        await prefs.setString('user_type', userType);

        if (userType == 'Тренер') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CoachProfileScreen()),
          );
        } else if (userType == 'Спортсмен') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AthleteProfileScreen()),
          );
        } else {
          throw Exception("Unknown user type");
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка входа: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/Logo.png', width: 60, height: 60),
                Text(
                  'FitnessGO',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Вход',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      textStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.normal),
                      padding: EdgeInsets.all(10.5),
                    ),
                    child: Text('Создать'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300),
                hintStyle: TextStyle(color: Colors.black),
                labelText: 'Почта',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Пароль',
                hintStyle: TextStyle(decorationColor: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 6, 98, 77),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                textStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w400, fontSize: 22),
              ),
              child: Text('Войти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 6, 98, 77),
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text('Забыли пароль?'),
            ),
          ],
        ),
      ),
    );
  }
}
