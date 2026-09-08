import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/pages/login_page.dart';
import 'package:flutter_application_2/views/pages/welcome_page.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authSErvices, child) {
        return StreamBuilder(
          stream: authService.value.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const CircularProgressIndicator.adaptive();
            } else if (snapshot.hasData) {
              widget = const LoginPage();
            } else {
              widget = pageIfNotConnected ?? const WelcomePage();
            }
            return widget;
          },
        );
      },
    );
  }
}
