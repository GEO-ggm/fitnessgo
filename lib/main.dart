// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitnessgo/main_set_screen.dart';
import 'package:fitnessgo/registration_screen.dart';
import 'package:fitnessgo/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'glav_screen.dart';
import 'main_set_category_screen.dart';



 void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Обеспечивает инициализацию виджетов перед запуском Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);// Асинхронно инициализируем Firebase
  runApp(MyApp()); // Старт
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitnessGO',
      
      theme: ThemeData(
        
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
        
        
      ),
       home: AuthorizationScreen(),
      //FitnessInterestScreen(userType: UserType.athlete,)
      
    );
    
  }
}

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  AuthorizationScreenState createState() => AuthorizationScreenState();
}

class AuthorizationScreenState extends State<AuthorizationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/back.png"), 
          fit:BoxFit.cover,)
          ),
      padding: EdgeInsets.all(18.0),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:40),
              Row(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
              Image.asset('assets/Logo.png', width: 60, height: 60,),
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
                Align (
                  alignment: Alignment.centerLeft,
                  child: Text('Вход',
                style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                  ),
                ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                  onPressed: (){
                    //TODO: Navigate to Registration
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
              
              // Phone input field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300,),
                  hintStyle: TextStyle(color:  Colors.black),
                  labelText: 'Телефон',
                   prefixText: '+7 ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Password input field
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
                    icon: Icon(_isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Login button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login logic
                },
                
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
                  // TODO: Implement forgot password logic
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                  );
                  
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 6, 98, 77),
                  textStyle: TextStyle(fontWeight: FontWeight.bold,),
                ),
                child: Text('Забыли пароль?'),
              ),
              // Create account button
              
            ],
          ),
        ),
        
      );
      
    
    
  }
}
