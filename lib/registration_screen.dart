// ignore_for_file: prefer_const_constructors



import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}


class _RegistrationScreenState extends State<RegistrationScreen>{
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  
  @override
  Widget build(BuildContext context){
    return Scaffold( 
      body: Container(
        
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/back.png"), 
          fit:BoxFit.cover,)
          ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
            SizedBox(height: 100),
            Image.asset('assets/Logo.png', width: 60, height: 60,), // Ассет логотипа
            Text(
              'FitnessGO',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                
                fontSize: 40,
              ),
            ),
            Text('Cоздать аккаунт',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,
            ),
            ),
            
            SizedBox(height: 80), // Пространство между элементами
            
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Телефон',
                hintStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            
            SizedBox(height: 10), // Пространство между элементами
            
            TextField(
              
              controller: _passwordController,
              obscureText: _isPasswordHidden,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Пароль',
                hintStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),
              
            ),
      
      SizedBox(height: 10),
      
      TextField(
              
              controller: _confirmPasswordController,
              obscureText: _isPasswordHidden,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Повторите пароль',
                hintStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),
              
            ),
      
      SizedBox(height: 15),
      
       ElevatedButton(
              onPressed: () {
                // Логика создания аккаунта
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Color.fromARGB(255, 6, 98, 77), //кнопка
                foregroundColor: Colors.white, // текст кнопки
                textStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w400, fontSize: 18),
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
              ), //   Стилизация кнопки регистрации
              child: Text('Зарегистрироваться'), // входящее кнопки
              
              ),
            
            
            TextButton(
              onPressed: () {
                // Переход обратно на экран входа
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor:Color.fromARGB(255, 6, 98, 77), ),
              child: Text('Уже есть аккаунт? Авторизоваться'),
            ),
          ],
        ),
      ),
    );
  }
}
