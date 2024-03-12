// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitnessGO',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
        
      ),
      home: AuthorizationScreen(),
    );
  }
}

class AuthorizationScreen extends StatefulWidget {
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
                Text('Вход',
                style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: (){
                    //TODO: Navigate to Registration

                  },
                  child: Text('Создать'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    textStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
                    
                  ),
                )
              ],
              ),
              SizedBox(height: 48),
              // Phone input field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Телефон',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Password input field
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
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
                child: Text('Войти'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password logic
                },
                child: Text('Забыли пароль?'),
              ),
              // Create account button
              
            ],
          ),
        ),
        
      );
      
    
    
  }
}
