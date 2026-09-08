import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/data/user_model.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/pages/profile/edit_profil_page.dart';
import 'package:flutter_application_2/views/pages/setting_page.dart';
import 'package:flutter_application_2/views/pages/welcome_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  void logout() async {
    try {
      await authService.value.signOut();
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
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserModel?>(
        stream: authService.value.getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data profil tidak di temuakan'));
          }
          UserModel user = snapshot.data!;

          return SingleChildScrollView(
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
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    left: 16,
                    right: 16,
                  ),
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
                        child: Center(
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 40),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          user.nama,
                          style: TextStyle(
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
                                  builder: (context) => EditProfilPage(
                                    nama: user.nama,
                                    pekerjaan: user.profession,
                                    bio: user.bio,
                                  ),
                                ),
                              );
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
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text(user.email),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey.shade700,
                              indent: 16,
                              endIndent: 16,
                            ),
                            ListTile(
                              leading: Icon(Icons.work),
                              title: Text(user.profession),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey.shade700,
                              indent: 16,
                              endIndent: 16,
                            ),
                            ListTile(
                              leading: Icon(Icons.description),
                              title: Text(user.bio),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
