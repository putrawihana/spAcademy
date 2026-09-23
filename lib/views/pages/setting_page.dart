import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/services/change_password.dart';
import 'package:flutter_application_2/services/delete_acount_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pwCtrl = TextEditingController();

  void alertDialogShow(BuildContext build) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(' Hapus Akun'),
          content: Column(
            children: [
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: pwCtrl,
                decoration: InputDecoration(labelText: 'PassWord'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text('settings', style: TextStyle(fontSize: 18)),
              icon: Icon(Icons.arrow_back),
            ),
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: ValueListenableBuilder(
                        valueListenable: isDarkNotifier,
                        builder: (context, isDark, child) {
                          return Text(isDark ? 'Dark Mode' : 'Light Mode');
                        },
                      ),
                      value: isDarkNotifier.value,
                      onChanged: (value) async {
                        setState(() {
                          isDarkNotifier.value = !isDarkNotifier.value;
                        });
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool(
                          KConstans.themeModeKey,
                          isDarkNotifier.value,
                        );
                      },
                    ),
                    Divider(height: 2, color: Colors.grey),
                    ListTile(
                      title: Text(
                        'Change Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
                      },
                    ),
                    Divider(height: 2, color: Colors.grey),
                    ListTile(
                      title: Text(
                        'Hapus Akun',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DeleteAcountPage();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
