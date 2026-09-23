import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditRiset extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;
  const EditRiset({super.key, required this.docId, required this.data});

  @override
  State<EditRiset> createState() => _EditRisetState();
}

class _EditRisetState extends State<EditRiset> {
  late TextEditingController tickerCtrl;
  late TextEditingController emitenCtrl;
  late TextEditingController judulCtrl;
  late TextEditingController descCtrl;
  late TextEditingController imageCtrl;
  late TextEditingController tpCtrl;
  late TextEditingController clCtrl;
  late TextEditingController entryCtrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState(); //mengabil isi riset yang sudah ada
    tickerCtrl = TextEditingController(text: widget.data['ticker'] ?? '');
    emitenCtrl = TextEditingController(text: widget.data['emiten'] ?? '');
    judulCtrl = TextEditingController(text: widget.data['judul'] ?? '');
    descCtrl = TextEditingController(text: widget.data['descripsi'] ?? '');
    imageCtrl = TextEditingController(text: widget.data['imageUrl'] ?? '');
    tpCtrl = TextEditingController(text: widget.data['takeProfit'] ?? '');
    clCtrl = TextEditingController(text: widget.data['stopLoss'] ?? '');
    entryCtrl = TextEditingController(text: widget.data['entryPoint'] ?? '');
  }

  @override
  void dispose() {
    tickerCtrl.dispose();
    emitenCtrl.dispose();
    judulCtrl.dispose();
    descCtrl.dispose();
    tpCtrl.dispose();
    clCtrl.dispose();
    imageCtrl.dispose();
    entryCtrl.dispose();
    super.dispose();
  }

  Future<void> updateResearch() async {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseFirestore.instance
          .collection('researches')
          .doc(widget.docId)
          .update({
            'ticker': tickerCtrl.text,
            'emiten': emitenCtrl.text,
            'judul': judulCtrl.text,
            'descripsi': descCtrl.text,
            'imageUrl': imageCtrl.text,
            'takeProfit': tpCtrl.text,
            'stopLoss': clCtrl.text,
            'entryPoint': entryCtrl.text,
          });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('something error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tickerCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kode Ticker (Misal : BULL)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emitenCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Emiten / Perusahaan',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: judulCtrl,
                decoration: const InputDecoration(labelText: 'Judul Riset'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Isi Analisis / Riset',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Link Image'),
              ),
              const SizedBox(height: 12),
              Row(
                spacing: 10,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: tpCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Take Profit',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: entryCtrl,
                      decoration: const InputDecoration(labelText: 'Entry'),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: clCtrl,
                      decoration: const InputDecoration(labelText: 'Stop Loss'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Publikasikan Riset'),
                onPressed: () async {
                  isLoading ? null : updateResearch();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Riset berhasil di Upload ke FireStore!'),
                    ),
                  );
                  tickerCtrl.clear();
                  emitenCtrl.clear();
                  judulCtrl.clear();
                  descCtrl.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
