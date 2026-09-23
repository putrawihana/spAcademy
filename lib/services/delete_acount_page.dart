import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:lottie/lottie.dart';

class DeleteAcountPage extends StatefulWidget {
  const DeleteAcountPage({super.key});

  @override
  State<DeleteAcountPage> createState() => _DeleteAcountPageState();
}

class _DeleteAcountPageState extends State<DeleteAcountPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController pwCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    pwCtrl.dispose();
    super.dispose();
  }

  void deletedCurrentAccount() async {
    try {
      await authService.value.deleteAccount(
        email: emailCtrl.text,
        password: pwCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Akun Berhasil di Hapus')));
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
    } catch (e) {
      String pesanError = e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(pesanError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Lottie.asset('assets/lotties/Avocado.json'),
              ),
              TextField(
                controller: emailCtrl,
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
              SizedBox(height: 10),
              TextField(
                controller: pwCtrl,
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
              SizedBox(height: 40),
              FilledButton(
                onPressed: deletedCurrentAccount,
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 40.0),
                ),
                child: Text('Hapus akun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
