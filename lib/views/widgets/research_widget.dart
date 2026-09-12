import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/services/auth_services.dart';
import 'package:flutter_application_2/views/pages/reseach/baca_research_page.dart';
import 'package:intl/intl.dart';

class ResearchWidget extends StatelessWidget {
  final int? jumlahResearch;
  const ResearchWidget({super.key, this.jumlahResearch});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return Column(
          children: [
            StreamBuilder(
              stream: authService.value.getUserDataStream(),
              builder: (context, userSnapshot) {
                final user = userSnapshot.data;
                final bool isUserVip = user?.isVip ?? false;

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
                            'Belum ada riser yang dipublikasi.',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }
                    var docs = snapshot.data!.docs;
                    if (jumlahResearch != null) {
                      docs = docs.take(jumlahResearch!).toList();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(4),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade700,
                                        borderRadius: BorderRadius.circular(4),
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
                                    onTap: () {
                                      if (isLocked) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Modul ini khusus member VIP! Hubungi admin untuk upgrade.',
                                            ),
                                            backgroundColor: Colors.amber,
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return BacaResearchPage(
                                                data: data,
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
