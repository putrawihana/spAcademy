import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/auth_services.dart';
import 'package:flutter_application_2/views/pages/reset_password_page.dart';
import 'package:flutter_application_2/views/widget_tree.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPw = TextEditingController();
  String pesanError = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text,
        password: controllerPw.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WidgetTree()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        pesanError = e.message ?? 'Something wrong';
      });
    }
  }

  void resetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordPage(email: controllerEmail.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Lottie.asset('assets/lotties/splebihbaru.json'),
            ),
            TextField(
              controller: controllerEmail,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Email',
              ),
              onEditingComplete: () {
                setState(() {});
              },
            ),
            SizedBox(height: 15),
            TextField(
              controller: controllerPw,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Password',
              ),
              onEditingComplete: () {
                setState(() {});
              },
            ),
            if (pesanError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(pesanError, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                loginUser();
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('login'),
            ),
            TextButton(
              onPressed: () {
                resetPassword();
              },
              child: Text('reset password'),
            ),
          ],
        ),
      ),
    );
  }
}
