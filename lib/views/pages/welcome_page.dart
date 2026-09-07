import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/login_page.dart';
import 'package:flutter_application_2/views/pages/register_page.dart';
import 'package:flutter_application_2/views/pages/terms_services_Page.dart';
import 'package:flutter_application_2/views/widgets/hero_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 250),
            HeroWidget(),
            SizedBox(height: 100),
            ValueListenableBuilder(
              valueListenable: isDarkNotifier,
              builder: (context, isDark, child) {
                return FittedBox(
                  child: Text(
                    'YOUR FINANCIAL ADVICE',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Color.fromARGB(255, 91, 103, 158),
                      fontWeight: FontWeight.bold,
                      fontSize: 80.0,
                      letterSpacing: 20.0,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegisterPage();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('Register'),
            ),
            SizedBox(height: 2),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TermsServicePage();
                    },
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('Terms & Services'),
            ),
          ],
        ),
      ),
    );
  }
}
