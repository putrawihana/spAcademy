import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/user_model.dart';
import 'package:flutter_application_2/services/auth_services.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  //agar berjalan lancar tanpa patah patah, ini alat bungkus khusus, wajib ada karena tab controller perlu vsyc
  late TabController
  tabController; //pakai late karena sekarang belum ada nilainya tapi pasti ada

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
    ); //this merujuk ke state adminpagestate, kerena udh pakai singletickerprovideranimasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          //memang pasangan ya tabBarView bis di scroll, mematikan halaman yang tidak aktif beda sama index stack di navbar
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Kelola VIP'),
            Tab(icon: Icon(Icons.article), text: 'Tambah Riset'),
            Tab(icon: Icon(Icons.video_collection), text: 'Tambah Modul'),
          ],
        ),
      ),
      body: TabBarView(
        controller:
            tabController, //harus pakai cotroller sama agar bisa connect dengan tabBar
        children: [
          _buildUserManagementTab(),
          _buildUploadResearchTab(),
          _buildUploadModuleTab(),
        ],
      ),
    );
  }

  Widget _buildUserManagementTab() {
    return StreamBuilder<List<UserModel>>(
      stream: authService.value.getAllUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final u = users[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(u.nama.isNotEmpty ? u.nama[0] : '?'),
              ),
              title: Text(u.nama),
              subtitle: Text(
                '${u.email}\nStatus: ${u.isVip ? "VIP" : " Reguler"}',
              ),
              isThreeLine:
                  true, //dasar nya listtile cuma dua baris karena subtile kepanjangan jadi menyesuaikan panjang subtilele
              trailing: Switch(
                value: u.isVip,
                onChanged: (value) async {
                  await authService.value.setUserVipStatus(
                    u.uid,
                    value,
                  ); //fungsinaya ada di auth servis
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status VIP ${u.nama} diubah jadi $value'),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUploadResearchTab() {
    final tickerCtrl = TextEditingController();
    final emitenCtrl = TextEditingController();
    final judulCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    final tpCtrl = TextEditingController();
    final slCtrl = TextEditingController();
    final entryCtrl = TextEditingController();
    bool isVipOnly =
        false; // memberikan flag ke research ini ketika pengecekan ketika modul dan user true research akan ke lock

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                      controller: slCtrl,
                      decoration: const InputDecoration(labelText: 'Stop Loss'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Khusus Member VIP'),
                value: isVipOnly,
                onChanged: (value) {
                  setState(() {
                    isVipOnly = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Publikasikan Riset'),
                onPressed: () async {
                  if (tickerCtrl.text.isEmpty || judulCtrl.text.isEmpty) return;
                  await authService.value.uploadResearch(
                    //alurnya : controller dapat data dari user kemudian di kirim ke upload research di auth service
                    //kemudian menjalankan uplaoad reserach yang mengirim data ini ke server
                    //dan pada kolom ini kita megisi required dangan controller kita
                    judul: judulCtrl.text,
                    ticker: tickerCtrl.text,
                    emiten: emitenCtrl.text,
                    descripsi: descCtrl.text,
                    imageUrl: imageCtrl.text,
                    takeProfit: tpCtrl.text,
                    stopLoss: slCtrl.text,
                    entryPoint: entryCtrl.text,
                    isVipOnly: isVipOnly,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Riset berhasil di Upload ke FireStore!'),
                    ),
                  );
                  tickerCtrl.clear();
                  emitenCtrl.clear();
                  judulCtrl.clear();
                  descCtrl.clear();
                  imageCtrl.clear();
                  tpCtrl.clear();
                  slCtrl.clear();
                  entryCtrl.clear();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadModuleTab() {
    final judulCtrl = TextEditingController();
    final videoCtrl = TextEditingController();
    String level = 'pemula';
    bool isVipOnly = false; //sama car kerjanya dengan yang di atas

    return StatefulBuilder(
      //kalo statelles tapi mau layar nya bisa berubah pakai setstate bisa pakai ini .
      // kalo di pisah state kode nya akan panjang makanya pakai statefull builder biar lebih ringkas
      builder: (context, setTabState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: judulCtrl,
                decoration: const InputDecoration(labelText: 'Judul Modul'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: videoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Link Video (YouTube / URL)',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue:
                    level, //nilai yang muncul ketika widget pertama kali di buat.
                decoration: const InputDecoration(labelText: 'Level Modul'),
                items: const [
                  DropdownMenuItem(value: 'pemula', child: Text('Pemula')),
                  DropdownMenuItem(value: 'menengah', child: Text('Menengah')),
                  DropdownMenuItem(value: 'lanjutan', child: Text('Lanjutan')),
                ],
                onChanged: (value) => setTabState(
                  () => level = value!,
                ), //karena pakai string biasa bukan nullabel jadi haru pake null asertion (!)
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Khusus Member VIP'),
                value: isVipOnly,
                onChanged: (value) => setTabState(() => isVipOnly = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.video_call),
                label: const Text('Simpan Modul Baru'),
                onPressed: () async {
                  if (judulCtrl.text.isEmpty || videoCtrl.text.isEmpty) return;
                  await authService.value.uploadModul(
                    judul: judulCtrl.text,
                    level: level,
                    videoUrl: videoCtrl.text,
                    isVipOnly: isVipOnly,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Modul video baru berhasi di simpan!'),
                    ),
                  );
                  judulCtrl.clear();
                  videoCtrl.clear();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
