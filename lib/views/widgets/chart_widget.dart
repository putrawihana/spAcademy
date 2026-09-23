import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/chart_model.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => ChartWidgetState();
}

class ChartWidgetState extends State<ChartWidget> {
  List<Watchlist> daftarSaham = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listenerStream();
  }

  Future<void> refreshData() async {
    await fetchAllData();
  }

  void listenerStream() async {
    setState(() {
      isLoading = false;
    }); //menangkap perubahan di stream
    authService.value.getWatchlistStream().listen((symbols) async {
      daftarSaham =
          symbols //symbols semua daftar saham di firestone
              .map(
                (s) => Watchlist(
                  symbol: s['symbol']!,
                  tittle: s['symbol']!,
                  subtittle: s['name']!,
                ),
              )
              .toList();
      await fetchAllData();
    });
  }

  Future<void> fetchAllData() async {
    //jadi pertama requst ke http, dapat data kemudian  di olah
    try {
      final responses = await Future.wait(
        //requst ke http
        daftarSaham.map(
          (s) => http.get(
            Uri.parse(
              'https://query1.finance.yahoo.com/v8/finance/chart/${s.symbol}',
            ),
          ),
        ),
      );

      setState(() {
        for (int i = 0; i < daftarSaham.length; i++) {
          if (responses[i].statusCode == 200) {
            final data = jsonDecode(responses[i].body);
            //JsonDecode untuk ubah dari data mentah jadi map<String, dynamic>
            //ini path nya harus masuk chart -> result[0] - meta
            //baru bisa akses field di dalam meta ex regularmarket price
            final meta = data['chart']['result'][0]['meta'];
            double current = meta['regularMarketPrice'] ?? 0.0;
            double percent = meta['regularMarketChangePercent'] ?? 0.0;
            daftarSaham[i].price = current.toStringAsFixed(0);
            daftarSaham[i].change =
                "${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(2)}%";
            daftarSaham[i].isPositive =
                percent >= 0; //kalo di bawah 0 maka false
          } else {
            daftarSaham[i].price = 'Gagal Memuat';
          }
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Terjadi Kesalahan $e');
    }
  }

  Future<void> _toggleWatchlist(String symbol) async {
    //symbol dari watclish bukan stocklist
    await authService.value.removeFromWatchlist(symbol);
  } //alur hapus datanya
  // triger ondismiss -> authremovewatch jalan -> uid yang sesuai menghapus symbol
  //-> streamwatchlist update -> listener denga data baru -> update ui

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (daftarSaham.isEmpty) {
      return const Center(child: Text('Belum Ada Saham di Watchlist.'));
    }
    return Card(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: daftarSaham.length,
        itemBuilder: (context, index) {
          final saham = daftarSaham[index];
          return Column(
            children: [
              Dismissible(
                key: ValueKey(saham.symbol), //yang membedakan tiap item
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),

                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                onDismissed: (direction) {
                  //ketika kotak sudah hilang aksi di jalankan
                  _toggleWatchlist(saham.symbol);
                },
                child: _buildStockCard(
                  title: saham.tittle,
                  subtitle: saham.subtittle,
                  price: saham.price,
                  percent: saham.change,
                  isPositive: saham.isPositive,
                ),
              ),
              if (index < daftarSaham.length - 1)
                const Divider(height: 1, thickness: 1, color: Colors.black12),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStockCard({
    required String title,
    required String subtitle,
    required String price,
    required String percent,
    required bool isPositive,
  }) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                KTextStyle.formatRibuan(price),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                percent,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
