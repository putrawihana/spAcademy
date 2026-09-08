import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/data/user_model.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/pages/reseaech/baca_research_page.dart';
import 'package:flutter_application_2/views/pages/upgrade_member_page.dart';
import 'package:flutter_application_2/views/widgets/container/container_benner.dart';
import 'package:flutter_application_2/views/widgets/vip_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResearchPage extends StatefulWidget {
  ResearchPage({super.key});

  @override
  State<ResearchPage> createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  int listResearch = 0;
  @override
  void initState() {
    super.initState();
    loadAlllike();
  }

  Future<void> loadAlllike() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < daftarResearch.length; i++) {
        daftarResearch[i].like = prefs.getInt('like_$i') ?? 0;
      }
    });
  }

  Future<void> simpanLike(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('like_$index', daftarResearch[index].like);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isDarkNotifier,
        builder: (context, isDark, child) {
          return Column(
            children: [
              ContainerBenner(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Icon(Icons.trending_up),
                        Text(
                          'Reset Saham',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: authService.value.getUserDataOnce(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('Data user tidak ditemuakn.'),
                          );
                        }
                        UserModel user = snapshot.data!;
                        return VipWidget(user: user);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemCount: daftarResearch.length,
                  itemBuilder: (context, index) {
                    final research = daftarResearch[index];
                    int selisihHari = DateTime.now()
                        .difference(research.tanggal)
                        .inDays;
                    return ValueListenableBuilder(
                      valueListenable: isMemberNotifier,
                      builder: (context, isMember, child) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return isMember
                                      ? BacaResearchPage(index: index)
                                      : UpgradeMemberPage();
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? Colors.white : Colors.black,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                isMember
                                    ? Container(
                                        width: double.infinity,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: Image.asset(
                                            research.gambar,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                              child: Image.asset(
                                                research.gambar,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 10,
                                                  sigmaY: 10,
                                                ),
                                                child: Container(
                                                  height: 200,
                                                  child: Center(
                                                    child: Icon(Icons.lock),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                Divider(height: 1, color: Colors.grey),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            research.emiten,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            DateFormat(
                                              'dd MMM yyyy',
                                              'id_ID',
                                            ).format(research.tanggal),
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        research.judul,
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Divider(
                                        height: 10,
                                        color: Colors.grey.shade700,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  research.like++;
                                                });
                                                simpanLike(index);
                                              },
                                              icon: Icon(
                                                Icons.thumb_up,
                                                color: Colors.black54,
                                              ),
                                              label: Text(
                                                research.like.toString(),
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '$selisihHari hari lalu',
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
