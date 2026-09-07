import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/reseaech/baca_research_page.dart';
import 'package:intl/intl.dart';

class ResearchWidget extends StatelessWidget {
  const ResearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            final research = DaftarResearch[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.white : Colors.grey,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        research.tipker,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 66, 145, 107),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    research.judul,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    research.descripsi,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 66, 145, 107),
                    ),
                  ),
                  SizedBox(height: 4),
                  Divider(height: 1, color: Colors.grey.shade400),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(research.tanggal),
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BacaResearchPage(index: index);
                              },
                            ),
                          );
                        },
                        child: Row(
                          spacing: 8,
                          children: [
                            Text(
                              'Baca Riset',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: Colors.black54,
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
  }
}
