import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/auth_services.dart';
import 'package:flutter_application_2/views/widget_tree.dart';
import 'package:flutter_application_2/views/widgets/hero_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPw = TextEditingController();
  String pesanError = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    try {
      await authService.value.createAccount(
        email: controllerEmail.text,
        password: controllerPw.text,
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroWidget(),
            SizedBox(height: 80),
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
                padding: EdgeInsets.all(8),
                child: Text(pesanError, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                registerUser();
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('Register'),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
