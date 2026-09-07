import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/profile/edit_profil_page.dart';
import 'package:flutter_application_2/views/pages/setting_page.dart';
import 'package:flutter_application_2/views/pages/welcome_page.dart';
import 'package:flutter_application_2/views/widgets/list_devider_widget.dart';
import 'package:flutter_application_2/views/widgets/vip_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String namaUser = "";
  String pekerjaanUser = "";
  String statusUser = "";
  String deskripsiUser = "";
  late FocusNode namaFocus;
  late FocusNode pekerjaanFocus;
  late FocusNode statusFocus;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    namaFocus = FocusNode();
    pekerjaanFocus = FocusNode();
    statusFocus = FocusNode();
    namaFocus.addListener(updateFocus);
    pekerjaanFocus.addListener(updateFocus);
    statusFocus.addListener(updateFocus);
    muatDataUser();
  }

  Future<void> muatDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaUser = prefs.getString('nama') ?? '';
      pekerjaanUser = prefs.getString('pekerjaan') ?? '';
      statusUser = prefs.getString('status') ?? '';
      deskripsiUser = prefs.getString('description') ?? '';
    });
  }

  void updateFocus() {
    setState(() {
      isEdit =
          namaFocus.hasFocus || pekerjaanFocus.hasFocus || statusFocus.hasFocus;
    });
  }

  void logout() async {
    try {
      selectedPageNotifier.value = 0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WelcomePage();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  void dispose() {
    namaFocus.dispose();
    pekerjaanFocus.dispose();
    statusFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              child: Image.asset(
                'assets/images/landscape.jpeg',
                color: Colors.teal,
                colorBlendMode: BlendMode.darken,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SettingPage();
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.settings),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            'assets/images/mentor.png',
                          ),
                        ),
                        VipWidget(),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      namaUser,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilPage(),
                            ),
                          );
                          await muatDataUser();
                          setState(() {});
                        },
                        label: Text('Edit Profil'),
                        icon: Icon(Icons.edit),
                      ),
                      Card(
                        child: TextButton.icon(
                          label: Text('Logout'),
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            logout();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(child: ListDeviderWidget()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
