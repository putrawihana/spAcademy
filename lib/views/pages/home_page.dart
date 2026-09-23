import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/pages/chart_page.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/widgets/chart_widget.dart';
import 'package:flutter_application_2/views/widgets/simple_widget/container_benner.dart';
import 'package:flutter_application_2/views/widgets/simple_widget/container_mentor.dart';
import 'package:flutter_application_2/views/widgets/simple_widget/hero_widget.dart';
import 'package:flutter_application_2/views/widgets/modul_widget.dart';
import 'package:flutter_application_2/views/widgets/research_widget.dart';
import 'package:flutter_application_2/views/widgets/vip_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ChartWidgetState> _chartKey = GlobalKey<ChartWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _chartKey.currentState?.refreshData();
        },
        child: StreamBuilder(
          stream: authService.value
              .getUserDataStream(), //mengambil data user dari server
          builder: (context, snapshot) {
            // yang membawa data bukan snapshot, dia cuma wrapper yang membawa status koneksi dan data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Data Tidak Tersedia'));
            }
            final user = snapshot
                .data!; //ketika data dari server belum sampai data snapshot.data akan bersifat null makanya perlu !
            // agar data ini di angap dan tidak crash, makanya ada loading sebelum ini di jalankan
            final bool isUserVip = user.isVip;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ContainerBenner(
                    child: ValueListenableBuilder(
                      valueListenable: isDarkNotifier,
                      builder: (context, isDark, child) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                          subtitle: Text(
                            user.nama, //stream builder tau kali di userdata ada nama
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
                          trailing: VipWidget(
                            user: user,
                          ), //dapat data vip atau ngk lalu di kirim ke vipwidget
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isUserVip == false) HeroWidget(),
                        SizedBox(height: 20),
                        ContainerMentor(
                          teksJoin: 'Diskusi lengkap di Group WA',
                        ),
                        SizedBox(height: 20),
                        if (isUserVip) ...[
                          Row(
                            spacing: 70,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tambahkan Saham ke Watchlist',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SearchStockPage();
                                      },
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          ChartWidget(key: _chartKey),
                        ],
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
      ),
    );
  }
}
