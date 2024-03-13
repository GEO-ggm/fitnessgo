// ignore_for_file: prefer_const_constructors



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: RegistrationScreen()));
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}




class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  
  Future <void> _registerUser() async {
    if(_formKey.currentState!.validate()){
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
      if (password != confirmPassword){
      _showDialog('Ошибка', 'Пароли не совпадают.');
      return;
      }
  try {
    // Регистрация пользователя через Firebase
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.sendEmailVerification();
    // Переход на главный экран приложения или показ сообщения об успешной регистрации
    _showDialog('Успех', 'Регистрация прошла успешно!');
  } on FirebaseAuthException catch (e) {
    // Обработка ошибок регистрации
    _showDialog('Ошибка Регистрации', e.message ?? 'Произошла ошибка.');
  }
}
}

void _showDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
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
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
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
            
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                hintStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
               validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Введите действительный адрес электронной почты';
                }
                return null;
              },
            ),
            
            SizedBox(height: 10), // Пространство между элементами
            
            TextFormField(
              
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
                  icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility,),
                  onPressed:  () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                ),
              ),
              
            ),
      
      SizedBox(height: 10),
      
      TextFormField(
              
              controller: _confirmPasswordController,
              obscureText: _isConfirmPasswordHidden,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Повторите пароль',
                hintStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w300,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isConfirmPasswordHidden = !_isConfirmPasswordHidden),
                ),
                  
                ),
              ),
             SizedBox(height: 10), 
            
          
        
      
       ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor:Color.fromARGB(255, 6, 98, 77), //кнопка
                foregroundColor: Colors.white, // текст кнопки
                textStyle: TextStyle(fontFamily: 'Light', fontWeight: FontWeight.w400, fontSize: 18),
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
              ), //   Стилизация кнопки регистрации
              child: Text('Зарегистрироваться'), // входящее кнопки
              ),
            
            
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor:Color.fromARGB(255, 6, 98, 77), ),
              child: Text('Уже есть аккаунт? Авторизоваться'),
            
          
              ),
          ],
        ),
       ),
      ),
    );
  }
  }

