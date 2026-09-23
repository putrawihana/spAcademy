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
  late TextEditingController namaController;
  late TextEditingController pekerjaanController;
  late TextEditingController descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super
        .initState(); //isi controller nya dari apa yang di kirim dari profilPage
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

  //jadi edit profil required 3 variable ini agar bisa dapat data sekarang(nama,pekerjaan,bio)
  //data yang di terima di update sehiga yang di firestore berubah
  void onSaveProfile() async {
    //di declar dulu isi controller di sini
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
      //required update kita kasih apa yang kita sudah ubah
      nama: nama,
      profession: pekerjaan,
      bio: bio,
    );
    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
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
          ? Center(child: CircularProgressIndicator())
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
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
