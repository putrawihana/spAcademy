import 'package:flutter/material.dart';

class UpgradeMemberPage extends StatelessWidget {
  UpgradeMemberPage({super.key});

  final List<String> benefits = [
    'Akses penuh 10+ Modul Video(Pemula, Menengah, Lanjutan)',
    'Research & Tesis Saham Eksklusif (Update tiap hari)',
    'Rekomendasi Entry Swing & Target Price',
    'Group komonitas Telegram VIP diskusi langsung bersama mentor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Akses VIP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Color(0xFFF59E0B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0xFFF59E0B), blurRadius: 4),
                      ],
                      color: Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.workspace_premium_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0xFFF59E0B), blurRadius: 2),
                      ],
                      color: Color.fromARGB(255, 129, 82, 1),
                      border: Border.all(color: Color(0xFFF59E0B), width: 1.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FittedBox(
                      child: Text(
                        'MEMBERSHIP TAHUNAN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Investasi Cerdas Untuk Portofolio Saham Anda',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Dapatkan bimbingan intensif 1 tahun penuh langsung bersama mentor berpengalaman',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFF59E0B), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VIP SP Academy 1 Tahun',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Akses Penuh Semua Modul & Research Eksklusif Mentor selama 365 Hari',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFF1E293B), width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp 1.499.000',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 4),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp 2.999.000',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Hanya -Rp 124.900/bulan (Hemat 50%)',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'APA YANG ANDA DAPATKAN :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: benefits.map((benefit) {
                        return ListTile(
                          leading: Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.greenAccent,
                          ),
                          title: Text(benefit, style: TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 2.0,
                            colors: [
                              Color.fromARGB(255, 246, 195, 107),
                              Color(0xFFF59E0B),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lanjut ke Pembayaran',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_rounded, size: 14, color: Colors.grey),
                        Text(
                          'semua lebih cepat dengan Qris',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
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
