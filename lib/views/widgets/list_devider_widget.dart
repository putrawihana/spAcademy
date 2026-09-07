import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemColumn {
  ItemColumn({required this.tittle, required this.icon});
  final String tittle;
  final Icon icon;
}

class ListDeviderWidget extends StatefulWidget {
  ListDeviderWidget({super.key});

  @override
  State<ListDeviderWidget> createState() => _ListDeviderWidgetState();
}

class _ListDeviderWidgetState extends State<ListDeviderWidget> {
  String pekerjaanUser = "";
  String statusUser = "";
  String deskripsiUser = "";

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
      pekerjaanUser = prefs.getString('pekerjaan') ?? '';
      statusUser = prefs.getString('status') ?? '';
      deskripsiUser = prefs.getString('description') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(leading: Icon(Icons.work), title: Text(pekerjaanUser)),
        Divider(
          height: 1,
          color: Colors.grey.shade700,
          indent: 16,
          endIndent: 16,
        ),
        ListTile(leading: Icon(Icons.info), title: Text(statusUser)),
        Divider(
          height: 1,
          color: Colors.grey.shade700,
          indent: 16,
          endIndent: 16,
        ),
        ListTile(leading: Icon(Icons.description), title: Text(deskripsiUser)),
      ],
    );
  }
}
