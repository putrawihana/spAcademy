import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/data/user_model.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/widgets/chart_widget.dart';
import 'package:flutter_application_2/views/widgets/container/container_benner.dart';
import 'package:flutter_application_2/views/widgets/container/container_mentor.dart';
import 'package:flutter_application_2/views/widgets/modul_widget.dart';
import 'package:flutter_application_2/views/widgets/research_widget.dart';
import 'package:flutter_application_2/views/widgets/vip_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: authService.value.getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          UserModel user = snapshot.data!;
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                ContainerBenner(
                  child: ValueListenableBuilder(
                    valueListenable: isDarkNotifier,
                    builder: (context, isDark, child) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            'assets/images/mentor.png',
                          ),
                        ),
                        subtitle: Text(
                          user.nama,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(
                          'Selamat Datang ',
                          style: TextStyle(
                            color: isDark ? Colors.amber : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: VipWidget(user: user),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerMentor(teksJoin: 'Diskusi lengkap di Group WA'),
                      SizedBox(height: 20),
                      ChartWidget(),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Lanjutkan Video',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ModulWidget(benner: false, jumlahTampilan: 1),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.trending_up_outlined),
                              SizedBox(width: 4),
                              Text(
                                'Recearch Terbaru',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              selectedPageNotifier.value = 2;
                            },
                            label: Text('tampilkan semua'),
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      ResearchWidget(jumlahResearch: 1, searchBar: false),
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
