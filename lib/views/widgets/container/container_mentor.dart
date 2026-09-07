import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/constans.dart';
import 'package:flutter_application_2/views/widgets/container/container_widget.dart';

class ContainerMentor extends StatelessWidget {
  const ContainerMentor({super.key, this.teksJoin});
  final String? teksJoin;

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/mentor.png'),
              ),
              SizedBox(width: 10),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        'Alghi Jofaril ',
                        style: KTextStyle.normalText(warna: Colors.black),
                      ),
                      Container(
                        padding: EdgeInsets.all(1),
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 2,
                          ),
                          color: const Color.fromARGB(255, 79, 179, 130),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'MENTOR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Full-time Equity Treader & Research Lead',
                    style: KTextStyle.descripsiText,
                  ),
                ],
              ),
            ],
          ),
          if (teksJoin != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(thickness: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(teksJoin!, style: const TextStyle(color: Colors.black54)),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(1),
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 108, 203, 247),
                        width: 2,
                      ),
                      color: const Color.fromARGB(255, 131, 196, 226),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.telegram, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
