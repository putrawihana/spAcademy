import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/pages/reseach/baca_research_page.dart';
import 'package:flutter_application_2/views/pages/reseach/edit_riset.dart';
import 'package:flutter_application_2/views/pages/upgrade_member_page.dart';
import 'package:intl/intl.dart';

class ResearchWidget extends StatefulWidget {
  final int? jumlahResearch;
  final bool? searchBar;
  const ResearchWidget({
    super.key,
    this.jumlahResearch,
    this.searchBar = false,
  });

  @override
  State<ResearchWidget> createState() => _ResearchWidgetState();
}

class _ResearchWidgetState extends State<ResearchWidget> {
  String ketikanPencariaan = '';
  final TextEditingController searchController = TextEditingController();

  void confirmedDelete(String docId, String judul) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Research?'),
        content: Text('Sudah Yakin Mau Hapus ini :>'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.value.deleteResearche(docId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil Menghapus Research Ini'),
                  ),
                );
              }
            },
            child: Text('hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return Column(
          children: [
            if (widget.searchBar!) ...[
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    ketikanPencariaan = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari research ......',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: ketikanPencariaan.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              ketikanPencariaan = '';
                            });
                          },
                          icon: Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
            ],
            StreamBuilder(
              stream: authService.value.getUserDataStream(),
              builder: (context, userSnapshot) {
                final user = userSnapshot.data;
                final bool isUserVip = user?.isVip ?? false;
                final bool isAdmin = user?.isAdmin ?? false;

                return StreamBuilder<QuerySnapshot>(
                  stream: authService.value.getResearchesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Belum ada Riset yang dipublikasi.',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }
                    var docs = snapshot.data!.docs;
                    if (widget.jumlahResearch != null) {
                      docs = docs.take(widget.jumlahResearch!).toList();
                    }
                    final query = ketikanPencariaan.trim().toLowerCase();
                    //cek dulu apakan ketikan ada kalo ngk ini ngk jalan
                    final SearchResearch = query.isEmpty
                        ? docs
                        : docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final judul = (data['judul'] ?? '')
                                .toString()
                                .toLowerCase();
                            return judul.contains(
                              ketikanPencariaan.toLowerCase(),
                            );
                          }).toList();

                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: SearchResearch.length,
                          itemBuilder: (context, index) {
                            final doc = SearchResearch[index];
                            final String docId = doc.id;
                            final data = doc.data() as Map<String, dynamic>;
                            final String ticker = data['ticker'] ?? 'SAHAM';
                            final String judul = data['judul'] ?? '-';
                            final String deskripsi = data['descripsi'] ?? '';
                            final bool isVipOnly = data['isVipOnly'] ?? false;
                            final bool isLocked = isVipOnly && !isUserVip;
                            DateTime tanggal = DateTime.now();
                            if (data['tanggal'] != null &&
                                data['tanggal'] is Timestamp) {
                              tanggal = (data['tanggal'] as Timestamp).toDate();
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 3),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              ticker,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                  255,
                                                  66,
                                                  145,
                                                  107,
                                                ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          if (isVipOnly)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber.shade700,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'VIP',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (isAdmin)
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return EditRiset(
                                                        docId: docId,
                                                        data: data,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                confirmedDelete(docId, judul);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.pinkAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    judul,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    deskripsi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.green.shade400
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Divider(
                                    height: 1,
                                    color: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'dd MMMM yyyy',
                                          'id_ID',
                                        ).format(tanggal),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (isLocked) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Modul ini khusus member VIP!',
                                                ),
                                                backgroundColor: Colors.amber,
                                                duration: const Duration(
                                                  milliseconds: 1000,
                                                ),
                                              ),
                                            );
                                            await Future.delayed(
                                              const Duration(seconds: 2),
                                            );
                                            if (!context.mounted) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return UpgradeMemberPage();
                                                },
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return BacaResearchPage(
                                                    data:
                                                        data, //data yang di kirim bedasarkna index
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Baca Riset',
                                              style: TextStyle(
                                                color: Colors.green.shade300,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 14,
                                              color: Colors.green.shade300,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
