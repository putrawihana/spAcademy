import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputResearch extends StatefulWidget {
  final int index;
  const InputResearch({super.key, required this.index});

  @override
  State<InputResearch> createState() => _InputResearchState();
}

class _InputResearchState extends State<InputResearch> {
  final TextEditingController penjelasanController = TextEditingController();
  final TextEditingController tpcontroller = TextEditingController();
  final TextEditingController entrycontroller = TextEditingController();
  final TextEditingController stoplosscontroller = TextEditingController();
  final TextEditingController judulcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bacaDataHp();
  }

  Future<void> simpanDataHP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'penjelasan_${widget.index}',
      penjelasanController.text,
    );
    await prefs.setString('takeprofit_${widget.index}', tpcontroller.text);
    await prefs.setString('stoploss_${widget.index}', stoplosscontroller.text);
    await prefs.setString('entry_${widget.index}', entrycontroller.text);
    await prefs.setString('judul_${widget.index}', judulcontroller.text);
  }

  Future<void> bacaDataHp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      penjelasanController.text =
          prefs.getString('penjelasan_${widget.index}') ?? '';
      penjelasanController.text =
          prefs.getString('takeprofit_${widget.index}') ?? '';
      penjelasanController.text =
          prefs.getString('stoploss_${widget.index}') ?? '';
      penjelasanController.text =
          prefs.getString('entry_${widget.index}') ?? '';
      penjelasanController.text =
          prefs.getString('judul_${widget.index}') ?? '';
    });
  }

  @override
  void dispose() {
    penjelasanController.dispose();
    tpcontroller.dispose();
    stoplosscontroller.dispose();
    judulcontroller.dispose();
    entrycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await simpanDataHP();
              isProfilChangeNotifier.value = !isProfilChangeNotifier.value;
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              _buildInputContainer(
                hintText: 'judul',
                controller: penjelasanController,
              ),
              SizedBox(height: 10),
              _buildInputContainer(
                hintText: 'penjelasan',
                controller: penjelasanController,
              ),
              SizedBox(height: 10),
              _buildInputContainer(
                hintText: 'take profit',
                controller: tpcontroller,
              ),
              SizedBox(height: 10),
              _buildInputContainer(
                hintText: 'stoploss',
                controller: stoplosscontroller,
              ),
              SizedBox(height: 10),
              _buildInputContainer(
                hintText: 'entry',
                controller: entrycontroller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({
    required String hintText,
    required TextEditingController controller,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
