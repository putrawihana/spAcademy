import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/notifier.dart';
import 'package:flutter_application_2/views/pages/upgrade_member_page.dart';

class VipWidget extends StatelessWidget {
  const VipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UpgradeMemberPage();
            },
          ),
        );
      },
      child: ValueListenableBuilder(
        valueListenable: isMemberNotifier,
        builder: (context, isMember, child) {
          return isMember
              ? Container(
                  padding: EdgeInsets.all(3),
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF59E0B), width: 2),
                    color: Colors.amber.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'VIP',
                      style: TextStyle(
                        letterSpacing: 4,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(1),
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF59E0B), width: 2),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Gabung Sekarang',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
