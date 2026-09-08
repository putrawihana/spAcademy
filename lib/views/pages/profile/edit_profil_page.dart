import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_services.dart';

class EditProfilPage extends StatefulWidget {
  final String nama;
  final String bio;
  final String pekerjaan;
  const EditProfilPage({
    super.key,
    required this.bio,
    required this.nama,
    required this.pekerjaan,
  });

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late TextEditingController namaController = TextEditingController();
  late TextEditingController pekerjaanController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    pekerjaanController = TextEditingController(text: widget.pekerjaan);
    descriptionController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    namaController.dispose();
    pekerjaanController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onSaveProfile() async {
    String nama = namaController.text.trim();
    String pekerjaan = pekerjaanController.text.trim();
    String bio = descriptionController.text.trim();

    if (nama.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong.')));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    String? error = await authService.value.updateProfile(
      nama: nama,
      profession: pekerjaan,
      bio: bio,
    );
    setState(() {
      _isLoading = false;
    });
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teks berhasil di perbarui.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Card(
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
                    onPressed: onSaveProfile,
                    label: Text('simpan Edit'),
                    icon: Icon(Icons.save),
                  ),
                ],
              ),
            ),
    );
  }
}
