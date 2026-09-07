import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/reseaech/input_research.dart';
import 'package:flutter_application_2/views/widgets/container/container_mentor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BacaResearchPage extends StatefulWidget {
  final int index;
  BacaResearchPage({super.key, required this.index});

  @override
  State<BacaResearchPage> createState() => _BacaResearchPageState();
}

class _BacaResearchPageState extends State<BacaResearchPage> {
  String penjelananResearch = '';
  String takeprofit = '';
  String entry = '';
  String stoploss = '';
  String judul = '';

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
    await prefs.reload();
    setState(() {
      penjelananResearch = prefs.getString('penjelasan_${widget.index}') ?? '';
      judul = prefs.getString('judul_${widget.index}') ?? '';
      takeprofit = prefs.getString('takeprofit_${widget.index}') ?? '';
      stoploss = prefs.getString('stoploss_${widget.index}') ?? '';
      entry = prefs.getString('entry_${widget.index}') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final research = DaftarResearch[widget.index];
    return Scaffold(
      appBar: AppBar(
        title: Text(research.emiten),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return InputResearch(index: widget.index);
                  },
                ),
              );
            },
            icon: Icon(Icons.abc),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RETURN SHOWCASE'),
                  Text(
                    DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                  ),
                ],
              ),
              Text(research.judul),
              SizedBox(height: 15),
              ContainerMentor(),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF0F172A),
                  border: Border.all(color: Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('setup Treding plan'),
                          Container(child: Text('Swing 4 Bulan')),
                        ],
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
                              border: Border.all(color: Color(0xFF1E293B)),
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
                                  entry,
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
                              border: Border.all(color: Color(0xFF1E293B)),
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
                                  takeprofit,
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
                              border: Border.all(color: Color(0xFF1E293B)),
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
                                  stoploss,
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
              Text('Tesis Investatasi & Rationale'),
              Text(penjelananResearch),
            ],
          ),
        ),
      ),
    );
  }
}
