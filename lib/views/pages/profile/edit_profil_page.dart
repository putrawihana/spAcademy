import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bacaDataHp();
  }

  Future<void> simpanDataHP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', namaController.text);
    await prefs.setString('pekerjaan', pekerjaanController.text);
    await prefs.setString('status', statusController.text);
    await prefs.setString('description', descriptionController.text);
  }

  Future<void> bacaDataHp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaController.text = prefs.getString('nama') ?? '';
      pekerjaanController.text = prefs.getString('pekerjaan') ?? '';
      statusController.text = prefs.getString('status') ?? '';
      descriptionController.text = prefs.getString('description') ?? '';
    });
  }

  @override
  void dispose() {
    namaController.dispose();
    pekerjaanController.dispose();
    statusController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/mentor.png'),
          ),
        ),
      ),
      body: Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: 'nama',
                  border: InputBorder.none,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: TextField(
                controller: pekerjaanController,
                decoration: InputDecoration(
                  hintText: 'pekerjaan',
                  border: InputBorder.none,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextField(
                controller: statusController,
                decoration: InputDecoration(
                  hintText: 'Status',
                  border: InputBorder.none,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'description',
                  border: InputBorder.none,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                await simpanDataHP();
                isProfilChangeNotifier.value = !isProfilChangeNotifier.value;
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              label: Text('simpan Edit'),
              icon: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
