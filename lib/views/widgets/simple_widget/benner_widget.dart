import 'dart:async';

import 'package:flutter/material.dart';

class BennerWidget extends StatefulWidget {
  const BennerWidget({super.key});

  @override
  State<BennerWidget> createState() => _BennerWidgetState();
}

class _BennerWidgetState extends State<BennerWidget> {
  final PageController _pageController = PageController();
  int halamanSekarng = 0;
  Timer? _timer; //jadikan nullble dulu biar baru jalan ketika inits

  List<String> daftarGambar = [
    'assets/images/slide1.png',
    'assets/images/slide2.png',
    'assets/images/slide3.png',
  ];

  @override
  void initState() {
    autoScroll();
    super.initState();
  }

  void autoScroll() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (halamanSekarng < daftarGambar.length - 1) {
        halamanSekarng++;
      } else {
        halamanSekarng = 0;
      }
      _pageController.animateToPage(
        //membuat animasi berpindah, perintahnya dari sini maskipun nilai halaman berubah tidak akan pengaruh tanpa ini
        halamanSekarng,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut, //lambat awal dan akhir cepat di antara
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); //pakai cencel bukan dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            //untuk membuar widget yang bisa di geser, 'builder' hanya di munculkan ketika di minta
            controller: _pageController,
            itemCount: daftarGambar.length,
            onPageChanged: (index) {
              setState(() {
                halamanSekarng = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(daftarGambar[index], fit: BoxFit.cover);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 180),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(daftarGambar.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: halamanSekarng == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: halamanSekarng == index ? Colors.teal : Colors.grey,
                  borderRadius: BorderRadius.circular(25),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
