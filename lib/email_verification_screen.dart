
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_set_screen.dart';
import 'dart:async';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
  

}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
   Timer? timer;


  @override
  void initState() {
    super.initState();

    // Пользователь должен быть в системе, чтобы попасть на этот экран
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      user.sendEmailVerification();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    // Обновляем статус пользователя
    await FirebaseAuth.instance.currentUser!.reload();
    var user = FirebaseAuth.instance.currentUser;

    // Если почта подтверждена, перенаправляем пользователя на главный экран
    if (user != null && user.emailVerified) {
      timer?.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupScreen())); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение Электронной Почты'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Мы отправили письмо с подтверждением на вашу электронную почту.'),
            const Text('Если вы не получили письмо, нажмите кнопку ниже, чтобы отправить еще раз.'),
            ElevatedButton(
              onPressed: () async {
                var user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.emailVerified) {
                  await user.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Письмо с подтверждением было отправлено.'),
                    ),
                  );
                }
              },
              child: const Text('Отправить письмо с подтверждением еще раз'),
            )
          ],
        ),
      ),
    );
  }
}
