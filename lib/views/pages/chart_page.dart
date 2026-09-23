import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';

class SearchStockPage extends StatefulWidget {
  const SearchStockPage({super.key});

  @override
  State<SearchStockPage> createState() => _SearchStockPageState();
}

class _SearchStockPageState extends State<SearchStockPage> {
  List<Map<String, String>> daftarSemuaSaham = [];
  List<Map<String, String>> hasilPencarian = [];
  List<String> watchlistSaatIni = [];
  bool isLoading = true;
  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  //daftarsemuasaham gudang data asli yang ngk bisa di ubah sebagai cadangan
  //hasil pencarian membilter berdasarkan
  //kemudian memfilter berdasarkan searchbox kalo ada
  Future<void> _loadData() async {
    final data = await authService.value.getStockList();
    setState(() {
      daftarSemuaSaham = data; //hanya untuk semua data
      hasilPencarian = data;
      isLoading = false;
    });

    // dengarkan watchlist realtime, supaya ikon berubah otomatis
    //cara mendegarkan stream harus pakai streambuilder atau listen
    authService.value.getWatchlistStream().listen((watchlistData) {
      if (mounted) {
        setState(() {
          watchlistSaatIni = watchlistData.map((w) => w['symbol']!).toList();
        });
      }
    });
  }

  //<<<<<<<<<<<cara hapus satu varible>>>>>>>>>>>
  // Future<void> removeLogo() async {
  //   final logoemiten = await FirebaseFirestore.instance
  //       .collection('stockList')
  //       .get();
  //   for (final doc in logoemiten.docs) {
  //     await doc.reference.update({'logoUrl': FieldValue.delete()});
  //     print('Logo dihapus: ${doc.data()['symbol']}');
  //   }
  //   print('Semua berhsil terhapus');
  // }

  void _onSearch(String query) {
    setState(() {
      hasilPencarian = daftarSemuaSaham.where((s) {
        final symbol = s['symbol']!.toLowerCase();
        final name = s['name']!.toLowerCase();
        final q = query.toLowerCase(); //apa perubahan di controller
        return symbol.contains(q) || name.contains(q);
      }).toList();
    });
  }

  Future<void> _toggleWatchlist(String symbol, String name) async {
    final sudahAda = watchlistSaatIni.contains(symbol);
    if (sudahAda) {
      await authService.value.removeFromWatchlist(symbol);
    } else {
      await authService.value.addToWatchlist(symbol, name);
    }
    // tidak perlu setState manual, karena getWatchlistStream() akan
    // otomatis kirim data baru dan trigger rebuild lewat listener di atas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Saham')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged:
                        _onSearch, //jadi setiap perubahan di controller akan menjalankan fungsi ini
                    decoration: InputDecoration(
                      hintText: 'Cari kode atau nama saham...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: hasilPencarian.isEmpty
                      ? const Center(child: Text('Saham tidak ditemukan'))
                      : ListView.builder(
                          itemCount: hasilPencarian.length,
                          itemBuilder: (context, index) {
                            final saham = hasilPencarian[index];
                            final symbol = saham['symbol']!;
                            final sudahDitambah = watchlistSaatIni.contains(
                              symbol,
                            );

                            return ListTile(
                              title: Text(
                                symbol,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(saham['name']!),
                              trailing: IconButton(
                                icon: Icon(
                                  sudahDitambah
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color: sudahDitambah
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: () =>
                                    _toggleWatchlist(symbol, saham['name']!),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
