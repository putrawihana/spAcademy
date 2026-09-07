import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/auth_services.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController controllerEmail = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String pesanError = '';

  @override
  void initState() {
    super.initState();
    controllerEmail.text = widget.email;
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  void reserPassword() async {
    try {
      await authService.value.resetPassword(email: controllerEmail.text);
      showSnackBar();
    } on FirebaseAuthException catch (e) {
      setState(() {
        pesanError = e.message ?? "Something Wrong";
      });
    }
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text('Please check your email'),
        showCloseIcon: true,
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
              child: Lottie.asset('assets/lotties/Avocado.json'),
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
            if (pesanError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(pesanError, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                reserPassword();
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}
