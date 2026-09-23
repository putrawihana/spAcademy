import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/services/reset_password_page.dart';
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
  final FocusNode passwordFocusNode = FocusNode();
  String pesanError = '';
  bool isLoading = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPw.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(
      () => isLoading = true,
    ); //di ubah true biar loading muncul dan tombol ngk bisa di ketik
    String? error = await authService.value.signIn(
      email: controllerEmail.text
          .trim(), //trim biar ngk ada space sebelum kalimant
      password: controllerPw.text.trim(),
    );
    setState(() {
      isLoading =
          false; //jadi false dan langsung ke navigator push kalo ngk ada error
    });
    if (!mounted) return;
    if (error != null) {
      setState(() {
        pesanError = error;
        controllerEmail.clear();
        controllerPw.clear();
      });
      FocusScope.of(context).unfocus();
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WidgetTree()),
      (route) => false,
    );
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                Navigator.pop(context);
              }
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
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
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(passwordFocusNode);
                        },
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
                        textInputAction: TextInputAction.done,
                        focusNode: passwordFocusNode,
                        onSubmitted: (value) {
                          loginUser();
                        },
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                      if (pesanError.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            pesanError,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 40),
                      FilledButton(
                        onPressed: () {
                          isLoading ? null : loginUser();
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 40.0),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            : Text('login'),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
