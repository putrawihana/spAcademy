import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/views/widgets/chart_widget.dart';
import 'package:flutter_application_2/views/widgets/container/container_benner.dart';
import 'package:flutter_application_2/views/widgets/container/container_mentor.dart';
import 'package:flutter_application_2/views/widgets/container/container_widget.dart';
import 'package:flutter_application_2/views/widgets/research_widget.dart';
import 'package:flutter_application_2/views/widgets/vip_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool tampilkanResearch = false;
  String namaUser = "";

  @override
  void initState() {
    super.initState();
    muatDataUser();
    isProfilChangeNotifier.addListener(() {
      if (mounted) {
        muatDataUser();
      }
    });
  }

  Future<void> muatDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaUser = prefs.getString('nama') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isDarkNotifier,
        builder: (context, isDark, child) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                ContainerBenner(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/mentor.png'),
                    ),
                    subtitle: ValueListenableBuilder(
                      valueListenable: isDarkNotifier,
                      builder: (context, isDark, child) {
                        return Text(
                          namaUser,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        );
                      },
                    ),
                    title: Text(
                      'Selamat Datang ',
                      style: TextStyle(
                        color: isDark ? Colors.amber : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: VipWidget(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerMentor(teksJoin: 'Gabung Group Telegram VIP'),
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
                      ContainerWidget(
                        onTap: () {
                          selectedPageNotifier.value = 1;
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.play_arrow),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'tutorial Membuka Rekening Saham',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Level 1',
                                  style: KTextStyle.descripsiText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                      ResearchWidget(),
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
