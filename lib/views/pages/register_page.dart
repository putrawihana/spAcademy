import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/widgets/hero_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPw = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  String pesanError = '';
  bool _isLoading = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    String nama = controllerNama.text.trim();
    String email = controllerEmail.text.trim();
    String password = controllerPw.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    String? error = await authService.value.register(
      email: email,
      password: password,
      nama: nama,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil di buat silahkan login.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
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
              controller: controllerNama,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'nama',
              ),
              onEditingComplete: () {
                setState(() {});
              },
            ),
            SizedBox(height: 15),
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
              onPressed: _isLoading
                  ? null
                  : () {
                      _handleRegister();
                    },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Register'),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
