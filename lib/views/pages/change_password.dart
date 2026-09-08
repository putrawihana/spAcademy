import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:lottie/lottie.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerCurentPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerNewPassword.dispose();
    controllerCurentPassword.dispose();
    super.dispose();
  }

  void updatePassword() async {
    try {
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: controllerCurentPassword.text,
        newPassword: controllerNewPassword.text,
        email: controllerEmail.text,
      );
      if (!mounted) return;
      showSnackBarSuccess();
      Navigator.pop(context);
    } catch (e) {
      String pesanError = e.toString();
      if (!mounted) return showSnackBarFailure(pesanError);
    }
  }

  void showSnackBarSuccess() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: Text('Password Change succesfully'),
        showCloseIcon: true,
      ),
    );
  }

  void showSnackBarFailure(String pesanError) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: Text(pesanError),
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
              height: 150,
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
            SizedBox(height: 10),
            TextField(
              controller: controllerCurentPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Current password',
              ),
              onEditingComplete: () {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: controllerNewPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'newPassword',
              ),
              onEditingComplete: () {
                setState(() {});
              },
            ),
            SizedBox(height: 40),
            FilledButton(
              onPressed: () {
                updatePassword();
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              child: Text('chage password'),
            ),
          ],
        ),
      ),
    );
  }
}
