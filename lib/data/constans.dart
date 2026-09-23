import 'package:flutter/material.dart';

class KConstans {
  static const String themeModeKey = 'themeModeKey';
}

class KTextStyle {
  static const TextStyle tittleText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static TextStyle normalText({Color? warna}) =>
      TextStyle(color: warna, fontSize: 15, fontWeight: FontWeight.bold);

  static const TextStyle descripsiText = TextStyle(
    color: Colors.black54,
    fontSize: 14,
  );

  static String formatRibuan(String angka) {
    String hasil = "";
    int panjang = angka.length;
    for (int i = 0; i < panjang; i++) {
      int posisiDariBelakang = panjang - 1 - i;
      hasil += angka[i];
      if (posisiDariBelakang % 3 == 0 && posisiDariBelakang > 0) {
        hasil += ".";
      }
    }
    return hasil;
  }
}
