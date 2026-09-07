import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/modul_video/video_player_page.dart';
import 'package:flutter_application_2/views/widgets/container/container_benner.dart';

class ModulPage extends StatefulWidget {
  ModulPage({super.key});

  @override
  State<ModulPage> createState() => _ModulPageState();
}

class _ModulPageState extends State<ModulPage> {
  List<isiModul> yangDiTampilin = [];

  @override
  void initState() {
    super.initState();
    yangDiTampilin = semuaModul;
  }

  void filterModul(String levelPilihan) {
    setState(() {
      if (levelPilihan == 'Semua Level') {
        yangDiTampilin = semuaModul;
      } else {
        yangDiTampilin = semuaModul
            .where(
              (modul) =>
                  modul.level.toLowerCase() == levelPilihan.toLowerCase(),
            )
            .toList();
      }
    });
  }

  final List<String> daftarLevel = [
    'Semua Level',
    'pemula',
    'menengah',
    'lanjutan',
  ];
  int indexAktif = 0;

  @override
  Widget build(BuildContext context) {
    int jumlahSelesai = semuaModul.where((m) => m.isCheck).length;
    int totalModul = semuaModul.length;
    double progresor = totalModul > 0 ? jumlahSelesai / totalModul : 0.0;

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isDarkNotifier,
        builder: (context, isDark, child) {
          return Column(
            children: [
              ContainerBenner(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modul Kelas Saham',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Kurikulum terstruktur oleh mentor',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF10B981),
                              width: 2,
                            ),
                            color: isDark
                                ? Color.fromARGB(255, 10, 82, 58)
                                : Color.fromARGB(255, 200, 228, 218),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            spacing: 5,
                            children: [
                              Text(
                                '$jumlahSelesai/$totalModul',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF10B981),
                                ),
                              ),
                              Text(
                                'Selesai',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progres Belajar Anda'),
                        Text('${(progresor * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        tween: Tween<double>(begin: 0.0, end: progresor),
                        builder: (context, animatedValue, child) {
                          return LinearProgressIndicator(
                            value: animatedValue,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? Colors.white12
                                : Colors.black26,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.greenAccent,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: daftarLevel.length,
                        itemBuilder: (context, index) {
                          final apakahAktif = index == indexAktif;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(daftarLevel[index]),
                              selected: apakahAktif,
                              selectedColor: Colors.greenAccent.shade700,
                              backgroundColor: isDark
                                  ? Color(0xFF1E293B)
                                  : Colors.white,
                              labelStyle: TextStyle(
                                color: apakahAktif
                                    ? Colors.white
                                    : Color(0xFFF10B981),
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSelected: (value) {
                                setState(() {
                                  indexAktif = index;
                                });
                                filterModul(daftarLevel[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemCount: yangDiTampilin.length,
                  itemBuilder: (context, index) {
                    final modul = yangDiTampilin[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.white : Colors.grey,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          final String pathVideoPilihan =
                              modul.video ?? 'assets/videos/1.mp4';
                          final String judulVideoPilihan = modul.judul;
                          final String levelVideoPilihan = modul.level;
                          final String ringkasanVideoPilihan =
                              modul.ringkasan ?? '';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VideoPlayerPage(
                                  videoPath: pathVideoPilihan,
                                  judul: judulVideoPilihan,
                                  level: levelVideoPilihan,
                                  ringakasan: ringkasanVideoPilihan,
                                );
                              },
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.play_arrow),
                              ),
                              title: Text(
                                modul.judul,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                'Level: ${modul.level}',
                                style: KTextStyle.descripsiText,
                              ),
                              trailing: Checkbox.adaptive(
                                value: modul.isCheck,
                                onChanged: (bool? nilaibaru) {
                                  setState(() {
                                    modul.isCheck = nilaibaru ?? true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
