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
}

// MODUL VIDEO
class isiModul {
  final String judul;
  final String level;
  final String? video;
  final String? ringkasan;
  bool isCheck;

  isiModul({
    required this.judul,
    required this.level,
    this.video,
    this.ringkasan,
    required this.isCheck,
  });
}

final List<isiModul> semuaModul = [
  isiModul(
    judul: 'Cara menjadi kaya',
    level: 'pemula',
    video: 'assets/videos/2.mov',
    ringkasan:
        'Dasar-Dasar Bursa Efek dan Pasar Modal: Membahas ekosistem pasar keuangan secara menyeluruh, termasuk fungsi utama bursa sebagai wadah bertemunya pihak yang membutuhkan dana dengan para investor.',
    isCheck: false,
  ),
  isiModul(judul: 'apaaja', level: 'menengah', isCheck: false),
  isiModul(judul: 'fiauhfua', level: 'lanjutan', isCheck: false),
  isiModul(
    judul: 'Cara menjadi kaya',
    level: 'menengah',
    video: 'assets/videos/2.mov',
    ringkasan:
        'Dasar-Dasar Bursa Efek dan Pasar Modal: Membahas ekosistem pasar keuangan secara menyeluruh, termasuk fungsi utama bursa sebagai wadah bertemunya pihak yang membutuhkan dana dengan para investor.',
    isCheck: false,
  ),
  isiModul(judul: 'apaaja', level: 'pemula', isCheck: false),
  isiModul(judul: 'fiauhfua', level: 'lanjutan', isCheck: false),
];

// CONTENT RESEARCH
class contentResearch {
  final String gambar;
  final String emiten;
  final DateTime tanggal;
  final String judul;
  int like;
  final String descripsi;
  final String tipker;

  contentResearch({
    required this.gambar,
    required this.emiten,
    required this.tanggal,
    required this.judul,
    required this.like,
    required this.descripsi,
    required this.tipker,
  });
}

final List<contentResearch> DaftarResearch = [
  contentResearch(
    tipker: 'BBCA',
    gambar: 'assets/images/bbca.png',
    emiten: 'PT.Bank Central Asia',
    tanggal: DateTime(2026, 08, 26),
    judul: 'Breaking News: Foreign Flow Masuk Rp 1.2T',
    like: 0,
    descripsi:
        'arus dana aring kembali mencatatkan net buy masih di BBRI setelah rilis kinerja NPL segment mikro yang terbukti....',
  ),
  contentResearch(
    tipker: 'BULL',
    gambar: 'assets/images/gambar.png',
    emiten: 'PT.Buana Listiya Lautan',
    tanggal: DateTime(2026, 04, 26),
    judul: 'return Saya di BULL: Rekap Swing TRade +31%',
    like: 0,
    descripsi:
        'rekap eksekusi swing trade Bull yang berhasill mengunci profil +31%, kini membentuk konsolikdai sehat ....',
  ),
  contentResearch(
    tipker: 'BBRI',
    gambar: 'assets/images/ihsg.png',
    emiten: 'PT.Bank Rakyat Indodesia',
    tanggal: DateTime(2026, 07, 10),
    judul: 'Breakout Resistance! Swing Trade BBRI +14.5%',
    like: 0,
    descripsi:
        'Analisis lanjutan pergerakan saham BBRI pasca breakout level psikologis, volume akumulasi asing mulai masuk signifikan ....',
  ),
];
