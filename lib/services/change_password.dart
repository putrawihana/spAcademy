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
  final FocusNode pwLamaFocus = FocusNode();
  final FocusNode pwBaruFocus = FocusNode();
  final formKey = GlobalKey<FormState>(); //mendapatkay key untuk validasi

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerNewPassword.dispose();
    controllerCurentPassword.dispose();
    pwBaruFocus.dispose();
    pwLamaFocus.dispose();
    super.dispose();
  }

  void updatePassword() async {
    if (!formKey.currentState!.validate())
      return; //! di awal = kebalikan nilai, ! akhir = paksa tidak null
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
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
                TextFormField(
                  //pakai fromfield untuk dapat kan validasi
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Email',
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(pwLamaFocus);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email tidak boleh kosong';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: controllerCurentPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Current password',
                  ),
                  focusNode: pwLamaFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(pwBaruFocus);
                  },
                  validator: (value) {
                    // di validasi agar mengirik data utuh ke server bukan data kosong atau ngk, memperingan server
                    if (value == null || value.isEmpty) {
                      return 'Password lama tidak boleh kosong';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: controllerNewPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'newPassword',
                  ),
                  focusNode: pwBaruFocus,
                  onFieldSubmitted: (_) {
                    if (formKey.currentState!.validate()) {
                      updatePassword();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password minimal 6 kerakter';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
                SizedBox(height: 40),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      updatePassword();
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.0),
                  ),
                  child: Text('chage password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
