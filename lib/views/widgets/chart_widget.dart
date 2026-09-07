import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  String priceIhsg = 'Loading ....';
  String priceBull = 'Loading ....';
  String changeIhsg = '';
  String changeBull = '';
  bool isIhsgPositive = true;
  bool isBullPositive = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataIhsg();
  }

  Future<void> fetchDataIhsg() async {
    try {
      final urlIhsg = Uri.parse(
        'https://query1.finance.yahoo.com/v8/finance/chart/^JKSE',
      );
      final urlBull = Uri.parse(
        'https://query1.finance.yahoo.com/v8/finance/chart/BULL.JK',
      );

      final result = await Future.wait([http.get(urlIhsg), http.get(urlBull)]);

      final responseIhsg = result[0];
      final responseBull = result[1];

      if (responseIhsg.statusCode == 200 && responseBull.statusCode == 200) {
        final dataIhsg = jsonDecode(responseIhsg.body);
        final metaIhsg = dataIhsg['chart']['result'][0]['meta'];
        double currentIhsg = metaIhsg['regularMarketPrice'] ?? 0.0;
        double prevCloseIhsg = metaIhsg['previousClose'] ?? currentIhsg;
        double diffIhsg = currentIhsg - prevCloseIhsg;
        double pctIhsg = (diffIhsg / prevCloseIhsg) * 100;

        final dataBull = jsonDecode(responseBull.body);
        final metaBull = dataBull['chart']['result'][0]['meta'];
        double currentBull = metaBull['regularMarketPrice'] ?? 0.0;
        double prevCloseBull = metaBull['previousClose'] ?? currentBull;
        double diffBull = currentBull - prevCloseBull;
        double pctBull = (diffBull / prevCloseBull) * 100;

        setState(() {
          priceIhsg = currentIhsg.toStringAsFixed(2);
          changeIhsg =
              "${pctIhsg >= 0 ? '+' : ''}${pctIhsg.toStringAsFixed(2)}%";
          isIhsgPositive = pctIhsg >= 0;

          priceBull = currentBull.toStringAsFixed(2);
          changeBull =
              "${pctBull >= 0 ? '+' : ''}${pctBull.toStringAsFixed(2)}%";
          isBullPositive = pctBull >= 0;
          isLoading = false;
        });
      } else {
        setState(() {
          priceIhsg = "Gagal memuat";
          priceBull = "Gagal memuat";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        priceIhsg = "error";
        priceBull = "error";
        isLoading = false;
      });
      debugPrint('terjadi kesalahan $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        _buildStockCard(
          title: 'IHSG',
          subtitle: 'Index Harga Saham Gabungan',
          price: priceIhsg,
          percent: changeIhsg,
          isPositive: isIhsgPositive,
        ),
        const SizedBox(height: 12),

        _buildStockCard(
          title: 'BULL',
          subtitle: 'Buana Listiya Lautan',
          price: priceBull,
          percent: changeBull,
          isPositive: isBullPositive,
        ),
      ],
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
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
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
                price,
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
