import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:intl/intl.dart';

class BacaResearchPage extends StatefulWidget {
  final Map<String, dynamic> data; //membaca berdasarkan riset yang di click

  BacaResearchPage({super.key, required this.data});

  @override
  State<BacaResearchPage> createState() => _BacaResearchPageState();
}

class _BacaResearchPageState extends State<BacaResearchPage> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final String ticker = data['ticker'] ?? '';
    final String judul = data['judul'] ?? '';
    final String deskripsi = data['descripsi'] ?? '';
    final String imageUrl = data['imageUrl'] ?? '';
    final String takeProfit = data['takeProfit'] ?? '';
    final String entryPoint = data['entryPoint'] ?? '';
    final String stopLoss = data['stopLoss'] ?? '';
    final List<String> paragrafList = deskripsi.split('\n');
    //pakai split untuk memecahkan jadi beberapa paragraph
    DateTime tanggal = DateTime.now();
    if (data['tanggal'] != null && data['tanggal'] is Timestamp) {
      // timestap format yang di gunakan di firestore
      tanggal = (data['tanggal'] as Timestamp).toDate();
    }

    return Scaffold(
      appBar: AppBar(title: Text(ticker)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal),
                    ),
                  ),
                  Text(
                    judul,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 15),
                  if (imageUrl.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  if (takeProfit.isNotEmpty &&
                      stopLoss.isNotEmpty &&
                      entryPoint.isNotEmpty) ...[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF0F172A),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'setup Treding plan',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF020617),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  width: 110,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Entry',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        KTextStyle.formatRibuan(
                                          '${data['entryPoint'] ?? '320'}',
                                        ),
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF020617),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  width: 110,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Target Price',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        KTextStyle.formatRibuan(
                                          '${data['takeProfit'] ?? '900'}',
                                        ),
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF020617),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  width: 110,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Stop Loss',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        KTextStyle.formatRibuan(
                                          '${data['stopLoss'] ?? '80'}',
                                        ),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Tesis Investatasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                  //... ini namanya spread oprator
                  //jadi ini perlu karena column cuma nerima List<Widget>
                  //dan paragraf beruapa List<String> makanya harus di ubah menjadi widget dengan cara loop,
                  // setelah di loop harus di keluarkan satu satu pakai spread operator kalo ngk dia masih satu kesatuaan
                  ...paragrafList.map((paragraf) {
                    if (paragraf.trim().isEmpty) {
                      return const SizedBox(height: 2);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        paragraf,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ), //heigt jarak atara baris jadi enak di baca
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
