import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/data/user_model.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/widgets/container/container_benner.dart';
import 'package:flutter_application_2/views/widgets/container/container_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ModulWidget extends StatefulWidget {
  final int? jumlahTampilan;
  final bool
  benner; // true = dipakai sendiri di ModulPage, false = ditempel di HomePage
  const ModulWidget({super.key, this.jumlahTampilan, this.benner = true});

  @override
  State<ModulWidget> createState() => _ModulWidgetState();
}

class _ModulWidgetState extends State<ModulWidget> {
  String selectedLevel = 'semua';

  Future<void> openDriverUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka link Google Drive.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return StreamBuilder<UserModel?>(
          stream: authService.value.getUserDataStream(),
          builder: (context, userSnapshot) {
            final user = userSnapshot.data;
            final bool isUserVip = user?.isVip ?? false;
            final bool isAdmin = user?.isAdmin ?? false;

            return StreamBuilder<QuerySnapshot>(
              stream: authService.value.getModulesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var allDocs = snapshot.data?.docs ?? [];
                if (widget.jumlahTampilan != null) {
                  allDocs = allDocs.take(widget.jumlahTampilan!).toList();
                }

                final int totalModul = allDocs.length;
                final int jumlahSelesai = allDocs
                    .where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['isCompleted'] ?? false;
                    })
                    .toList()
                    .length;
                final filteredDocs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final level = (data['level'] ?? '').toString().toLowerCase();
                  if (selectedLevel == 'semua') return true;
                  return level == selectedLevel;
                }).toList();

                // ============================================================
                // BAGIAN YANG DIPERBAIKI: konten daftar modul disimpan
                // di satu variable dulu, supaya tidak ditulis 2 kali.
                // ============================================================
                Widget kontenModul = filteredDocs.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada modul untuk level ini.',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: widget.benner
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              )
                            : EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final String judul = data['judul'] ?? "Modul";
                          final String level = data['level'] ?? 'pemula';
                          final String videoUrl = data['videoUrl'] ?? '';
                          final bool isVipOnly = data['isVipOnly'] ?? false;
                          final bool isLocked =
                              isVipOnly && !isUserVip && !isAdmin;
                          final bool isCompleted = data['isCompleted'] ?? false;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 2),
                              ],
                            ),
                            child: ContainerWidget(
                              onTap: () {
                                if (isLocked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Modul ini khusus member VIP! Hubungi admin untuk upgrade.',
                                      ),
                                      backgroundColor: Colors.amber,
                                    ),
                                  );
                                } else if (videoUrl.isNotEmpty) {
                                  widget.benner
                                      ? openDriverUrl(videoUrl)
                                      : selectedPageNotifier.value = 1;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Link video belum tersedia.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            isLocked
                                                ? Icons.lock
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  judul,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                if (isVipOnly)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.amber.shade700,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'VIP',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Text(
                                              level.toUpperCase(),
                                              style: KTextStyle.descripsiText,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isAdmin)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever_outlined,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _comformingDelete(doc.id, judul),
                                        ),
                                      if (isUserVip)
                                        Checkbox(
                                          value: isCompleted,
                                          onChanged: (bool? value) async {
                                            await authService.value
                                                .updateModuleCompletion(
                                                  doc.id,
                                                  value ?? false,
                                                );
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                // ============================================================
                // Susunan akhir Column: header (ContainerBenner) HANYA muncul
                // kalau widget.benner == true. Konten modul dibungkus Expanded
                // HANYA kalau widget.benner == true (dipakai sendiri di
                // ModulPage, tinggi terbatas dari Scaffold). Kalau false
                // (ditempel di HomePage yang scroll-nya SingleChildScrollView,
                // tinggi TAK terbatas), konten modul dipakai langsung TANPA
                // Expanded karena sudah shrinkWrap.
                // ============================================================
                return Column(
                  children: [
                    if (widget.benner)
                      ContainerBenner(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 8,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Modul Kelas Saham',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      'Kurikulum terstruktur oleh mentor',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFF10B981),
                                      width: 2,
                                    ),
                                    color: isDark
                                        ? const Color.fromARGB(255, 10, 82, 58)
                                        : const Color.fromARGB(
                                            255,
                                            200,
                                            228,
                                            218,
                                          ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Text(
                                        '$jumlahSelesai/$totalModul',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                      const Text(
                                        'Selesai',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Progres Belajar Anda'),
                                Text(
                                  '${totalModul == 0 ? 0 : ((jumlahSelesai / totalModul) * 100).toStringAsFixed(0)}%',
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: totalModul == 0
                                    ? 0.0
                                    : (jumlahSelesai / totalModul),
                                minHeight: 8,
                                backgroundColor: isDark
                                    ? Colors.white12
                                    : Colors.black26,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.greenAccent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  _buildFilterChip('semua', 'semua'),
                                  _buildFilterChip('pemula', 'pemula'),
                                  _buildFilterChip('menengah', 'menengah'),
                                  _buildFilterChip('lanjutan', 'lanjutan'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // <-- INI BAGIAN UTAMA PERBAIKANNYA -->
                    widget.benner ? Expanded(child: kontenModul) : kontenModul,
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String levelKey, String label) {
    final bool isSelected = selectedLevel == levelKey;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.teal,
        disabledColor: Colors.amber,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              selectedLevel = levelKey;
            });
          }
        },
      ),
    );
  }

  void _comformingDelete(String docId, String judul) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Modul?'),
        content: Text('Apakah Anda yakin ingin menghapus "$judul"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await authService.value.deleteModule(docId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Modul berhasil dihapus')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
