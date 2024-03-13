import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmationScreen extends StatefulWidget {
  final String phoneNumber;

  ConfirmationScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final TextEditingController _codeController = TextEditingController();
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Если аутентификация успешна, перейдите на следующий экран
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          // Показать сообщение об ошибке
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        // Показать поле для ввода кода
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  _confirmCode() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _codeController.text.trim(),
      );

      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      if (user != null) {
        // Перейти на экран при успешной верификации
      } else {
        // Сообщение об ошибке, если пользователь не найден
      }
    } catch (e) {
      // Обработка ошибок
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Подтверждение')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Введите код',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'На ваш телефон отправлено SMS с кодом подтверждения.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'SMS код',
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) => _confirmCode(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _confirmCode,
              child: Text('Подтвердить'),
            ),
          ],
        ),
      ),
    );
  }
}