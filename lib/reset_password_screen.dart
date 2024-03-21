// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
_ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>{
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/back.png"), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),     
            Image.asset('assets/Logo.png', width: 60, height: 60,), // Ассет логотипа
            Text('FitnessGO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            ),

            SizedBox(height: 10),          
            Text('Восстановить пароль',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            ),
            SizedBox(height: 80),

            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: ' Телефон',
                hintStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300, decorationColor: Colors.grey),
                prefixText:'+7',
                prefixStyle: TextStyle(decorationColor: Colors.black, fontSize: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)
                ),
              ),
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 18),
              onTap: () {
                //Настройка фокуса на поле
                if(_phoneController.text == 'Телефон'){
                  setState(() {
                    _phoneController.text = '+7';
                  });
                }
              },
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

              },

              
              style: ElevatedButton.styleFrom (
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 6, 98, 77),
                textStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w400, fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ), 
              child: Text('Восстановить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Вернуться обратно'),

            ),


          ],
        ),
      ),
    );
  }
}