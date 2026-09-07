import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController controller = TextEditingController();
  bool isDark = false;
  String? menuItem = 'e1';
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
            Container(
              padding: EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      child: Center(
                        child: SwitchListTile(
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
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Center(
                        child: ListTile(
                          title: Text('Change Password'),
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
                      ),
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
